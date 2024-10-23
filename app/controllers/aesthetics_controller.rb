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

      def reload_demo
        @aesthetic = Aesthetic.find(params[:id])
        
        if @aesthetic.update(aesthetic_params)
          respond_to do |format|
            format.html { render partial: "shared/#{params[:game_id]}" }
          end
        else
          render json: { error: @aesthetic.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
      end

      private

      def aesthetic_params
        params.require(:aesthetic).permit(:primary_clr, :secondary_clr, :tertiary_clr, :font_clr, :font)
      end
end
