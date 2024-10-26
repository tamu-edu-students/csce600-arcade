class WordsService
  # currently using datamuse API. documentation: https://www.datamuse.com/api/
  def self.define(word)
    uri = URI("https://api.datamuse.com/words?sp=#{word}&md=d&max=1")
    response = Net::HTTP.get(uri)
    info = JSON.parse(response)
    info[0]['word'].upcase == word.upcase ? info[0]['defs'][0] : ''
  end

  def self.words(letters)
    uri = URI("https://api.datamuse.com/words?sp=#{URI.encode_www_form_component("*#{letters[0]}*+#{letters}")}&md=f")
    response = Net::HTTP.get(uri)
    words = JSON.parse(response)
  
    usable_words = words.select do |word_data|
      frequency = word_data['tags'][0][/\d+\.\d+/].to_f
      word_data['word'].length > 3 && frequency > 0.5 && word_data['word'] =~ /^[a-zA-Z]+$/
    end.map { |word_data| word_data['word'] }
  
    usable_words
    end

  def self.word?(word)
    uri = URI("https://api.datamuse.com/words?sp=#{word}&md=f&max=1")
    response = Net::HTTP.get(uri)
    info = JSON.parse(response)
  
    if info[0]['word'].upcase == word.upcase
      frequency = info[0]['tags'][0][/\d+\.\d+/].to_f
      return true if frequency > 0.5
    end
  
    false
  end
end