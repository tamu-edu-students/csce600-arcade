every 1.minutes do
    command "echo 'Running?'"
    rake "wordle:add_new_wordle_words", environment: "development"
end
