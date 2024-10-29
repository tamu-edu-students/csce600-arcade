class BoxesController < ApplicationController
  def play
    # @bee = Bee.find_by(play_date: Date.today)
    # while @bee.nil?
    #   letters = ("A".."Z").to_a.shuffle[0, 7].join
    #   valid_words = WordsService.words(letters)
    #   if valid_words.length > 20
    #     @bee = Bee.create(letters: letters, play_date: Date.today)
    #   end
    # end
    @aesthetic = Aesthetic.find_by(game_id: Game.find_by(name: "Letter Boxed").id)

    session[:lbscore] ||= 0
    session[:lbwords] ||= []

    render "letterboxed"
  end
end
