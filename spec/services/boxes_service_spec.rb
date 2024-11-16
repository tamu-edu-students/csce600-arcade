# spec/services/bees_service_spec.rb
require 'rails_helper'

RSpec.describe BoxesService, type: :service do
  before do
    LetterBox.destroy_all()
    allow(BoxesService).to receive(:get_letters).and_return([ "i", "h", "r", "e", "w", "n", "p", "c", "s", "l", "a", "k" ])
    allow(WordsService).to receive(:words).with("iewnpcslak", true).and_return([ "ick" ])
    allow(WordsService).to receive(:words).with("hewnpcslak", true).and_return([ "hack" ])
    allow(WordsService).to receive(:words).with("rewnpcslak", true).and_return([ "ranks", "rank", "rana" ])
    allow(WordsService).to receive(:words).with("eihrpcslak", true).and_return([ "each" ])
    allow(WordsService).to receive(:words).with("wihrpcslak", true).and_return([ "wick" ])
    allow(WordsService).to receive(:words).with("nihrpcslak", true).and_return([ "nip" ])
    allow(WordsService).to receive(:words).with("pihrewnlak", true).and_return([ "pin" ])
    allow(WordsService).to receive(:words).with("cihrewnlak", true).and_return([ "can" ])
    allow(WordsService).to receive(:words).with("sihrewnlak", true).and_return([ "shawl" ])
    allow(WordsService).to receive(:words).with("lihrewnpcs", true).and_return([ "leper" ])
    allow(WordsService).to receive(:words).with("aihrewnpcs", true).and_return([ "ark" ])
    allow(WordsService).to receive(:words).with("kihrewnpcs", true).and_return([ "kicks" ])
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
