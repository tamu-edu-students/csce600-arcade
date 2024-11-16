# spec/services/bees_service_spec.rb
require 'rails_helper'

RSpec.describe BeesService, type: :service do
  before do
    Bee.destroy_all()
  end

  describe '.set_week_bee' do
    it 'calls set_day_bee for each date in the week starting from tomorrow' do
      allow(WordsService).to receive(:words).and_return(Array.new(25, ""))
      BeesService.set_week_bee
      bees = Bee.where(play_date: Date.tomorrow..Date.tomorrow + 7).order(:play_date)
      expect(bees.length).to eq(7)
    end
  end

  describe '.set_day_bee' do
    it 'sets game for today by default' do
      allow(WordsService).to receive(:words).and_return(Array.new(25, ""))
      BeesService.set_day_bee()
      bee = Bee.find_by(play_date: Date.today)
      expect(bee).to be_truthy
    end
  end

  describe '.guess' do
    before do
      Bee.create(play_date: Date.today, letters: "ARUCHIT", ranks: [ 0, 0, 0, 0 ])
    end
    it 'already guessed' do
      allow(WordsService).to receive(:word?).and_return(true)
      words, score, message = BeesService.guess('chair', [ 'CHAIR' ], 0)
      expect(message).to include(/You have already guessed that!/)
    end

    it 'valid guess' do
      allow(WordsService).to receive(:word?).and_return(true)
      words, score, message = BeesService.guess('chair', [], 0)
      expect(score).to eq(2)
    end
  end
end
