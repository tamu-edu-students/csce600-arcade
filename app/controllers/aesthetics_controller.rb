class AestheticsController < ApplicationController
    def index
      end

      def create
      end

      def edit
        @aesthetic = Aesthetic.find_by(game_id: params[:game_id])
      end

      def update
        @aesthetic = Aesthetic.find_by(game_id: params[:game_id])
        if @aesthetic.update(aesthetic_params)
          flash[:notice] = "Aesthetic was successfully updated."
          render :edit
        else
          flash[:notice] = "Aesthetic was not updated."
          render :edit
        end
      end

      def live_demo
        @aesthetic = Aesthetic.find(params[:id])
        render partial: "shared/#{@aesthetic.game_id}", locals: { aesthetic: @aesthetic }
      end

      def destroy
      end

      private

      def aesthetic_params
        params.require(:aesthetic).permit(:primary_clr, :secondary_clr, :tertiary_clr, :font_clr, :font)
      end
end
