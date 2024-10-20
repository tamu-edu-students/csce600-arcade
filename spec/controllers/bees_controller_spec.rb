# spec/controllers/bees_controller_spec.rb
require 'rails_helper'

RSpec.describe BeesController, type: :controller do
    describe "#dictionary_check" do
      let(:valid_word) { 'foot' }
      let(:invalid_word) { 'xyzzy' }

      it "returns true for a valid word in the dictionary" do
        allow(HTTP).to receive(:get).and_return(
            double(status: double(success?: true), parse: [ {} ])
        )
        expect(controller.send(:dictionary_check, valid_word)).to be true
      end

      it "returns false for an invalid word not in the dictionary" do
        allow(HTTP).to receive(:get).and_return(
            double(status: double(success?: true), parse: [])
        )
        expect(controller.send(:dictionary_check, invalid_word)).to be false
      end
    end

    describe "#valid_word?" do
      let(:valid_letters) { %w[A B C D O F] }
      let(:center_letter) { 'T' }
      before do
        session[:sbwords] = []
      end
      it "returns true for a valid word" do
        allow(controller).to receive(:dictionary_check).and_return(true)
        expect(controller.send(:valid_word?, 'BATT', valid_letters, center_letter)).to be true
      end
      it "returns false if the word does not include the center letter" do
        expect(controller.send(:valid_word?, 'FOOD', valid_letters, center_letter)).to be false
        expect(flash[:sb]).to eq("The word must include the center letter 'T'.")
      end
      it "returns false if the word contains invalid letters" do
        allow(controller).to receive(:dictionary_check).and_return(true)
        expect(controller.send(:valid_word?, 'CAXT', valid_letters, center_letter)).to be false
        expect(flash[:sb]).to eq("The word must be composed of the letters: A, B, C, D, O, F.")
      end
      it "returns false if the word is not in the dictionary" do
        allow(controller).to receive(:dictionary_check).and_return(false)
        expect(controller.send(:valid_word?, 'BATT', valid_letters, center_letter)).to be false
        expect(flash[:sb]).to eq("The word 'BATT' is not in the dictionary.")
      end
    end
end
