module Game2048
  class AestheticsController < ApplicationController
    before_action :set_aesthetic

    def edit
      initialize_game if session[:game_2048_board].nil?
    end

    def update
      if @aesthetic.update(aesthetic_params)
        redirect_to edit_game_2048_aesthetic_path, notice: '2048 theme updated successfully.'
      else
        render :edit
      end
    end

    def preview
      if @aesthetic.update(aesthetic_params)
        initialize_game if session[:game_2048_board].nil?
        render partial: "game2048/preview_board", layout: false
      else
        render json: { error: @aesthetic.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    def set_aesthetic
      @game = Game.find_by(name: "2048")
      @aesthetic = Aesthetic.find_by(game_id: @game.id)
    end

    def aesthetic_params
      params.require(:aesthetic).permit(:font, colors: [])
    end

    def initialize_game
      session[:game_2048_board] = Array.new(4) { Array.new(4, 0) }
      session[:game_2048_score] = 0
      2.times { add_new_tile }
    end

    def add_new_tile
      empty_cells = []
      session[:game_2048_board].each_with_index do |row, i|
        row.each_with_index do |cell, j|
          empty_cells << [i, j] if cell == 0
        end
      end
      
      if empty_cells.any?
        cell = empty_cells.sample
        session[:game_2048_board][cell[0]][cell[1]] = [2, 4].sample
      end
    end
  end
end