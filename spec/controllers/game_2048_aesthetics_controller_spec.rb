require 'rails_helper'

RSpec.describe Game2048::AestheticsController, type: :controller do
  before do
    Game.destroy_all
    @game = Game.create(name: '2048', game_path: 'game_2048_play_path')
    @user = User.create(email: 'test@example.com', first_name: 'Test', last_name: 'User')
    @aesthetic = Aesthetic.create(
      game_id: @game.id,
      colors: [ '#CDC1B4', '#EEE4DA', '#EDE0C8' ],
      labels: [ 'background', 'tile-2', 'tile-4' ],
      font: 'Clear Sans'
    )
    session[:user_id] = @user.id
  end

  describe "GET #edit" do
    context "when user is Puzzle Aesthetician" do
      before do
        Role.find_or_create_by!(user_id: @user.id, role: "Puzzle Aesthetician")
      end

      it "allows access to aesthetic settings" do
        get :edit, params: { id: @aesthetic.id, use_route: :game_2048_aesthetics_edit }
        expect(response).to have_http_status(:success)
        expect(assigns(:aesthetic)).to eq(@aesthetic)
      end
    end
  end

  # describe "PATCH #update" do
  #   before do
  #     Role.create(user_id: @user.id, role: "Puzzle Aesthetician")
  #   end

  #   it "updates aesthetic settings" do
  #     new_colors = ['#CDC1B4', '#FF5733', '#EDE0C8']
  #     patch :update, params: {
  #       id: @aesthetic.id,
  #       use_route: :game_2048_aesthetics_update,
  #       aesthetic: {
  #         colors: new_colors,
  #         font: 'Arial'
  #       }
  #     }

  #     @aesthetic.reload
  #     expect(@aesthetic.colors).to eq(new_colors)
  #     expect(@aesthetic.font).to eq('Arial')
  #     expect(flash[:notice]).to include("2048 theme updated successfully")
  #   end

  #   # it "handles invalid updates" do
  #   #   patch :update, params: {
  #   #     id: @aesthetic.id,
  #   #     use_route: :game_2048_aesthetics_update,
  #   #     aesthetic: {
  #   #       colors: []
  #   #     }
  #   #   }

  #   #   expect(response).to render_template(:edit)
  #   # end
  # end
end
