# Handles modifications to the WordleDictionary by a Puzzle Setter
class WordleDictionariesController < ApplicationController
  before_action :check_session_id

  # GET /wordle_dictionaries or /wordle_dictionaries.json
  # Returns both HTML content and JSON content, the request must specify required response format
  #
  # For JSON requests, the following parameters can be specified (all the parameters can be requested together):
  # @param [Boolean] only_solutions requests only valid solutions to be returned
  # @param [Boolean] sort_asc toggles alphabetical sorting on the returned words
  # @param [String] word_part requests only words that are prefixed by specified string
  def index
    if request.format.json?
      query = WordleDictionary
        .where("word LIKE ?", "#{params[:word_part]}%")
        .order(word: sort_order)

      @wordle_dictionaries = filter_only_solutions(query)
      render json: { success: true, words: @wordle_dictionaries }, status: 200
    else
      @wordle_dictionaries = WordleDictionary.order(:word)
      render :index
    end
  end

  # PATCH /wordle_dictionaries/amend_dict or /wordle_dictionaries/amend_dict.json
  #
  # @param [String] new_words '\\n' separated string of words to be used for update
  # @param [String] update_opt 'add' for simple insert, 'replace' to overwrite existing dictionary or 'remove' to remove provided words. On 'add', existing words will be updated to provided parameters.
  # @param [Boolean] valid_solutions specifies whether words are valid solutions or not
  def amend_dict
    errors = []
    if validate_amend_dict_params
      new_words = parse_words_from_str
      delete_opt = params[:update_opt] == "replace"
      add_opt = delete_opt || params[:update_opt] == "add"
      errors = update_db(new_words, delete_opt, add_opt)
    else
      errors << "Please provide a list of valid words and select an update option"
    end

    if errors.empty?
      render json: { success: true }, status: 200
    else
      render json: { success: false, errors: errors }, status: 500
    end
  end

  # PATCH /wordle_dictionaries/reset_dict or /wordle_dictionaries/reset_dict.json
  #
  # Resets the active WordleDictionary to the default original copy (WordleDictionaryBackup)
  def reset_dict
    new_words = WordleDictionaryBackup.all.map { |record| { word: record.word, is_valid_solution: record.is_valid_solution } }
    errors = update_db(new_words, true, true)
    if errors.empty?
      render json: { success: true }, status: 200
    else
      render json: { success: false, errors: errors }, status: 500
    end
  end

  private
    # Only allow a list of trusted parameters through.
    def wordle_dictionary_params
      params.require(:wordle_dictionary).permit(:word, :is_valid_solution)
    end

    def update_db(words, delete, add)
      errors = []
      ActiveRecord::Base.transaction do
        begin
          if delete
            WordleDictionary.destroy_all
          end

          if add
            add_words(words)
          else
            remove_words(words)
          end

        rescue ActiveRecord::RecordInvalid => e
          errors << "Failed to update dictionary: #{e.message}"
          raise ActiveRecord::Rollback
        end
      end
      errors
    end

    def add_words(words)
      words.each do |word|
        exists = WordleDictionary.find_by(word: word[:word].downcase)
        if exists.nil?
          WordleDictionary.find_or_create_by!(word: word[:word].downcase, is_valid_solution: word[:is_valid_solution])
        else
          exists.is_valid_solution = word[:is_valid_solution]
          exists.save
        end
      end
    end

    def remove_words(words)
      words.each do |word|
        exists = WordleDictionary.find_by(word: word[:word].downcase)
        exists.destroy if exists
      end
    end

    def sort_order
      (params[:sort_order] ||= "asc").to_sym
    end

    def filter_only_solutions(query)
      if params[:only_solutions] == "true"
        query.where(is_valid_solution: true)
      else
        query
      end
    end

    def parse_words_from_str
      params[:new_words].split("\n").map { |word|
        { word: word.chomp.strip, is_valid_solution: params[:valid_solutions] }
      }
    end

    def validate_amend_dict_params
      params[:new_words].present? && params[:update_opt].present? && !params[:valid_solutions].nil?
    end

    def check_session_id
      if session[:guest] == true
        redirect_to wordles_play_path and return
      end

      all_admins_and_setters = Role.where("role = 'System Admin' OR role = 'Puzzle Setter'")

      if all_admins_and_setters.empty?
        redirect_to welcome_path, alert: "You are not authorized to access this page."
      elsif all_admins_and_setters.map(&:user_id).exclude?(session[:user_id])
        redirect_to wordles_play_path
      end
    end
end
