# Handles aesthetic modifications
class AestheticsController < ApplicationController
  # @return [nil]
  # @deprecated no use
  def index
  end

  # @return [nil]
  # @deprecated no use
  def create
  end

  # This method sets the aesthetic object to be edited
  #
  # @param [Integer] id the id of aesthetic object to be edited
  # @return [Aesthetic]
  def edit
    @aesthetic = Aesthetic.find_by(id: params[:id])
  end

  # This method updates the aesthetic object
  #
  # @param [Integer] id the id of aesthetic object to be updated
  # @param [Hash] aesthetic_params the updates to be made
  # @return [Aesthetic]
  def update
    @aesthetic = Aesthetic.find_by(id: params[:id])
    if @aesthetic.update(aesthetic_params)
      redirect_to edit_aesthetic_path(@aesthetic), notice: "Aesthetic was successfully updated."
    else
      redirect_to edit_aesthetic_path(@aesthetic), alert: "Aesthetic was not updated."
    end
  end

  # This method uploads the dummy Aesthetic model for the partial view
  #
  # @param [Integer] id the id of aesthetic object to be updated (hardcoded demo is currently -1)
  # @param [Hash] aesthetic_params the updates to be made
  # @return [Aesthetic]
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

  # @return [nil]
  # @deprecated no use
  def destroy
  end

  private

  def aesthetic_params
    params.require(:aesthetic).permit(:font, colors: [])
  end
end
