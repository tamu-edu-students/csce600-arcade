# spec/services/bees_service_spec.rb
require 'rails_helper'

RSpec.describe BoxesService, type: :service do
  before do
    LetterBox.destroy_all()
    allow(BoxesService).to receive(:get_letters).and_return([ "i", "h", "r", "e", "w", "n", "p", "c", "s", "l", "a", "k" ])
    allow(WordsService).to receive(:words_by_first_letter).with("iewnpcslak").and_return([ "ick" ])
    allow(WordsService).to receive(:words_by_first_letter).with("hewnpcslak").and_return([ "hack" ])
    allow(WordsService).to receive(:words_by_first_letter).with("rewnpcslak").and_return([ "ranks", "rank", "rana" ])
    allow(WordsService).to receive(:words_by_first_letter).with("eihrpcslak").and_return([ "each" ])
    allow(WordsService).to receive(:words_by_first_letter).with("wihrpcslak").and_return([ "wick" ])
    allow(WordsService).to receive(:words_by_first_letter).with("nihrpcslak").and_return([ "nip" ])
    allow(WordsService).to receive(:words_by_first_letter).with("pihrewnlak").and_return([ "pin" ])
    allow(WordsService).to receive(:words_by_first_letter).with("cihrewnlak").and_return([ "can" ])
    allow(WordsService).to receive(:words_by_first_letter).with("sihrewnlak").and_return([ "shawl" ])
    allow(WordsService).to receive(:words_by_first_letter).with("lihrewnpcs").and_return([ "leper" ])
    allow(WordsService).to receive(:words_by_first_letter).with("aihrewnpcs").and_return([ "ark" ])
    allow(WordsService).to receive(:words_by_first_letter).with("kihrewnpcs").and_return([ "kicks" ])
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
