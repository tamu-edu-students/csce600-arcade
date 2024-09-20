require 'rails_helper'

RSpec.describe 'Health', type: :request do
    it 'returns a valid 200 HTTP status' do
        get '/up'
        expect(response).to be_successful
    end
end