require 'rails_helper'

RSpec.describe WordsService do
  describe '.define' do
    it 'returns the definition when the word is found' do
      word = 'example'
      definition = 'a representative form or pattern'
      response_body = [ { "word" => word, "defs" => [ definition ] } ].to_json

      allow(Net::HTTP).to receive(:get).and_return(response_body)

      result = WordsService.define(word)
      expect(result).to eq(definition)
    end

    it 'returns nothing when the word is not found' do
      word = 'aaaaa'
      definition = 'lots of as'
      response_body = [ { "word" => word, "defs" => [ definition ] } ].to_json

      allow(Net::HTTP).to receive(:get).and_return(response_body)

      result = WordsService.define("aaaab")
      expect(result).to eq("")
    end
  end

  describe '.words' do
    it 'returns a list of usable words that match the criteria' do
      letters = 'a'
      words_response = [
        { "word" => "apple", "tags" => [ "f:2.3" ] },
        { "word" => "ant", "tags" => [ "f:1.1" ] },
        { "word" => "aardvark", "tags" => [ "f:0.9" ] }
      ].to_json

      allow(Net::HTTP).to receive(:get).and_return(words_response)

      result = WordsService.words(letters)
      expect(result).to contain_exactly('apple', 'aardvark')
    end
  end

  describe '.word?' do
    it 'returns true if the word exists and has a high enough frequency' do
      word = 'apple'
      response_body = [ { "word" => word, "tags" => [ "f:2.5" ] } ].to_json

      allow(Net::HTTP).to receive(:get).and_return(response_body)

      result = WordsService.word?(word)
      expect(result).to be true
    end

    it 'returns false if the word does not meet the frequency threshold' do
      word = 'rareword'
      response_body = [ { "word" => word, "tags" => [ "f:0.3" ] } ].to_json

      allow(Net::HTTP).to receive(:get).and_return(response_body)

      result = WordsService.word?(word)
      expect(result).to be false
    end
  end
end
