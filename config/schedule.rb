every 1.day do
    rake "wordle:add_new_wordle_words", environment: "development"
    rake "bee:new_bee", environment: "development"
end
