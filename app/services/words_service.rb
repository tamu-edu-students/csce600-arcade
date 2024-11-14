# Handles Datamuse API calls for dictionary and definition.
#
# @see https://www.datamuse.com/api/ Datamuse API documentation
class WordsService
  # This method returns the definition of a given word
  #
  # @param [String] word you want definition for
  # @return [String] definiton of word
  # @example
  #   "WordsService.define("chair")" #=> "n\tAn item of furniture used to sit on or in, comprising a seat, legs or wheels, back, and sometimes arm rests, for use by one person. Compare stool, couch, sofa, settee, loveseat and bench."
  def self.define(word)
    uri = URI("https://api.datamuse.com/words?sp=#{word}&md=d&max=1")
    response = Net::HTTP.get(uri)
    info = JSON.parse(response)
    return false if info.empty?
    if info[0]["word"].casecmp(word).zero? && info[0].key?("defs")
      info[0]["defs"][0]
    else
      ""
    end
  end

  # This method returns the list of valid words that can be formed by a given sequence of letters
  #
  # @param [String] letters sequence of letters
  # @return [Array<String>] list of valid words that always include the first character of letters
  # @example
  #   "WordsService.words("aruchit")" #=> ["catch", "chair", "chart", "tacit", ... ]
  def self.words(letters)
    uri = URI("https://api.datamuse.com/words?sp=#{URI.encode_www_form_component("*#{letters[0]}*+#{letters}")}&md=f")
    response = Net::HTTP.get(uri)
    words = JSON.parse(response)

    usable_words = words.select do |word_data|
      frequency = word_data["tags"][0][/\d+\.\d+/].to_f
      word_data["word"].length > 3 && frequency > 0.5 && word_data["word"] =~ /^[a-zA-Z]+$/
    end.map { |word_data| word_data["word"] }

    usable_words
  end

  # This method returns the list of valid words that can be formed by a given sequence of letters and START with the first letter

  def self.words_by_first_letter(letters)
    uri = URI("https://api.datamuse.com/words?sp=#{URI.encode_www_form_component("#{letters[0]}*+#{letters}")}&md=f")
    response = Net::HTTP.get(uri)
    words = JSON.parse(response)

    usable_words = words.select do |word_data|
      frequency = word_data["tags"][0][/\d+\.\d+/].to_f
      word_data["word"].length > 3 && frequency > 0.5 && word_data["word"] =~ /^[a-zA-Z]+$/
    end.map { |word_data| word_data["word"] }

    usable_words
  end

  # This method checks if a given word is valid
  #
  # @param [String] word to be checked for validity
  # @return [Boolean] based on frequency per one million words
  # @example
  #   "WordsService.word?("happy")" #=> True
  #   "WordsService.word?("aaeer")" #=> False
  def self.word?(word)
    uri = URI("https://api.datamuse.com/words?sp=#{word}&md=f&max=1")
    response = Net::HTTP.get(uri)
    info = JSON.parse(response)

    if info.empty?
      false
    elsif info[0]["word"].upcase == word.upcase
      frequency = info[0]["tags"][0][/\d+\.\d+/].to_f
      return true if frequency > 0.4
    end

    false
  end
end
