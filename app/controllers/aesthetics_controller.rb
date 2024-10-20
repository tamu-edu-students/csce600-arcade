class AestheticsController < ApplicationController
    def index
      end

      def create
      end

      def show
        @aesthetic = Aesthetic.find_by(game_id: params[:game_id].to_i)
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

      def destroy
      end

      private

      def aesthetic_params
        params.require(:aesthetic).permit(:primary_clr, :secondary_clr, :tertiary_clr, :font_clr, :font)
      end
end
