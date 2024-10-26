class AestheticsController < ApplicationController
  def index
  end

  def create
  end

  def edit
    @aesthetic = Aesthetic.find_by(id: params[:id])
  end

  def update
    @aesthetic = Aesthetic.find_by(id: params[:id])
    if @aesthetic.update(aesthetic_params)
      redirect_to edit_aesthetic_path(@aesthetic), notice: "Aesthetic was successfully updated."
    else
      redirect_to edit_aesthetic_path(@aesthetic), alert: "Aesthetic was not updated."
    end
  end

<<<<<<< HEAD
  def reload_demo
    @aesthetic = Aesthetic.find(params[:id])
    
    if @aesthetic.update(aesthetic_params)
      respond_to do |format|
        format.html { render partial: "shared/#{params[:game_id]}" }
=======
      def reload_demo
        @aesthetic = Aesthetic.find(params[:id])

        if @aesthetic.update(aesthetic_params)
          respond_to do |format|
            format.html { render partial: "shared/#{params[:game_id]}" }
          end
        else
          render json: { error: @aesthetic.errors.full_messages }, status: :unprocessable_entity
        end
>>>>>>> 082f585 (SCRUM-57, allows deactivation of all roles, allow guests to access game but not any config settings)
      end
    else
      render json: { error: @aesthetic.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
  end

  private

  def aesthetic_params
    params.require(:aesthetic).permit(:font, colors: [])
  end
end
