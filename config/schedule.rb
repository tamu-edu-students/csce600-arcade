every 1.day do
    rake "wordle:add_new_wordle_words", environment: "production"
    rake "bee:new_bee", environment: "production"
end
