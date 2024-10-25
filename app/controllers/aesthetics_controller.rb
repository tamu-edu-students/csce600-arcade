class AestheticsController < ApplicationController
  def index
  end

  def create
  end

  def edit
    @aesthetic = Aesthetic.find_by(id: params[:id])
  end

  def update
    puts aesthetic_params
    @aesthetic = Aesthetic.find_by(id: params[:id])
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
        format.html { render partial: "shared/1" }
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
