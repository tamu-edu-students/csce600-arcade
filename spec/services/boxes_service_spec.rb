# spec/services/bees_service_spec.rb
require 'rails_helper'

RSpec.describe BoxesService, type: :service do
  before do
    LetterBox.destroy_all()
  end

  describe '.set_week_boxes' do
    it 'calls set_day_box for each date in the week starting from tomorrow' do
      BoxesService.set_week_boxes
      boxes = LetterBox.where(play_date: Date.tomorrow..Date.tomorrow + 7).order(:play_date)
      expect(boxes.length).to eq(7)
    end
  end

  describe '.set_day_box' do
    it 'sets game for today by default' do
      BoxesService.set_day_box()
      box = LetterBox.find_by(play_date: Date.today)
      expect(box).to be_truthy
    end
  end
end
