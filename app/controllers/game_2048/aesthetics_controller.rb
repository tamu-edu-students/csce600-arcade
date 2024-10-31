module Game2048
  class AestheticsController < ApplicationController
    before_action :set_aesthetic

    def edit
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


  end
end