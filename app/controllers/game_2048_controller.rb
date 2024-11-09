class Game2048Controller < ApplicationController
  def play
    @aesthetic = Aesthetic.find_by(game_id: Game.find_by(name: "2048").id)
    initialize_game if session[:game_2048_board].nil?
  end

  def show
    redirect_to game_2048_play_path
  end

  def make_move
    direction = params[:direction]
    moved = false
    board = session[:game_2048_board].map(&:dup)

    case direction
    when "up"
      moved = move_up
    when "down"
      moved = move_down
    when "left"
      moved = move_left
    when "right"
      moved = move_right
    end

    if moved
      add_new_tile
      update_score(session[:game_2048_score])
      check_game_over
    end

    respond_to do |format|
      format.json {
        render json: {
          board: session[:game_2048_board],
          score: session[:game_2048_score],
          game_over: session[:game_2048_over],
          won: session[:game_2048_won]
        }
      }
    end
  end

  def new_game
    initialize_game
    redirect_to game_2048_play_path
  end

  private

  def initialize_game
    session[:game_2048_board] = Array.new(4) { Array.new(4, 0) }
    session[:game_2048_score] = 0
    session[:game_2048_over] = false
    session[:game_2048_won] = false
    2.times { add_new_tile }
    setup_stats
  end

  def add_new_tile
    empty_cells = []
    session[:game_2048_board].each_with_index do |row, i|
      row.each_with_index do |cell, j|
        empty_cells << [ i, j ] if cell == 0
      end
    end

    if empty_cells.any?
      cell = empty_cells.sample
      session[:game_2048_board][cell[0]][cell[1]] = [ 2, 4 ].sample
    end
  end

  def move_left
    moved = false
    board = session[:game_2048_board]
    4.times do |i|
      new_row = merge_line(board[i])
      if new_row != board[i]
        moved = true
        board[i] = new_row
      end
    end
    moved
  end

  def move_right
    moved = false
    board = session[:game_2048_board]
    4.times do |i|
      new_row = merge_line(board[i].reverse).reverse
      if new_row != board[i]
        moved = true
        board[i] = new_row
      end
    end
    moved
  end

  def move_up
    moved = false
    board = session[:game_2048_board]
    4.times do |j|
      column = board.map { |row| row[j] }
      new_column = merge_line(column)
      if new_column != column
        moved = true
        4.times { |i| board[i][j] = new_column[i] }
      end
    end
    moved
  end

  def move_down
    moved = false
    board = session[:game_2048_board]
    4.times do |j|
      column = board.map { |row| row[j] }.reverse
      new_column = merge_line(column).reverse
      if new_column != column.reverse
        moved = true
        4.times { |i| board[i][j] = new_column[i] }
      end
    end
    moved
  end

  def merge_line(line)
    # Remove zeros and merge identical numbers
    non_zero = line.reject(&:zero?)
    merged = []
    i = 0
    while i < non_zero.length
      if i + 1 < non_zero.length && non_zero[i] == non_zero[i + 1]
        merged << non_zero[i] * 2
        session[:game_2048_score] += non_zero[i] * 2
        i += 2
      else
        merged << non_zero[i]
        i += 1
      end
    end
    # Pad with zeros to maintain length
    merged + Array.new(4 - merged.length, 0)
  end

  def check_game_over
    board = session[:game_2048_board]
    # Check for 2048 tile
    session[:game_2048_won] = board.any? { |row| row.any? { |cell| cell >= 2048 } }

    # If there are empty cells, game is not over
    return if board.any? { |row| row.include?(0) }

    # Check for possible merges horizontally and vertically
    3.times do |i|
      4.times do |j|
        # Check horizontal merge possibility
        if j < 3 && board[i][j] == board[i][j + 1]
          return
        end
        # Check vertical merge possibility
        if board[i][j] == board[i + 1][j]
          return
        end
      end
    end

    # Check last row horizontal merges
    3.times do |j|
      if board[3][j] == board[3][j + 1]
        return
      end
    end

    session[:game_2048_over] = true
  end

  def setup_stats
    if session[:user_id].present?
      game_id = Game.find_by(name: "2048").id
      DashboardService.new(session[:user_id], game_id, 0).call
    end
  end

  def update_score(score)
    if session[:user_id].present?
      game_id = Game.find_by(name: "2048").id
      DashboardService.new(session[:user_id], game_id, score).update_score
    end
  end
end
