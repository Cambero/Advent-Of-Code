# frozen_string_literal: true

class BingoBoard
  def initialize(str, rule_to_win)
    @rule_to_win = rule_to_win
    @board = str.split("\n").map { _1.split.map(&:to_i) }
    @unmarked = {}
    @board.each_with_index do |row, y|
      row.each_with_index do |number, x|
        @unmarked[number] = [y, x]
      end
    end
  end

  def play(number)
    mark!(number) if can_mark?(number)

    self
  end

  def score
    @unmarked.keys.sum * @last_marked
  end

  def finished?
    @finished
  end

  private

  def can_mark?(number)
    !@finished && @unmarked[number]
  end

  def mark!(number)
    @last_marked = number
    mark_number
    check_finish
  end

  def mark_number
    @board[@unmarked[@last_marked].first][@unmarked[@last_marked].last] = true
    @unmarked.delete(@last_marked)
  end

  def check_finish
    @finished = true if @rule_to_win.call(@board)
  end
end

class Game
  attr_accessor :play_number

  def initialize(rule_to_win_board, rule_to_win_game, filename = 'input')
    numbers, *rest = File.open(filename).read.split("\n\n")
    @numbers = numbers.split(',').map(&:to_i).each
    @boards  = rest.map { BingoBoard.new(_1, rule_to_win_board) }
    @rule_to_win_game = rule_to_win_game
  end

  def play!
    while @play_number = @numbers.next
      @boards.each do |board|
        next unless board.play(play_number).finished?

        return board.score if @rule_to_win_game.call(@boards)
      end
    end
  end
end

# rules_to_win_board
_all_marked = ->(arr) { arr.all? (true) }
win_with_one_row_marked = ->(board) { board.any? { _all_marked.call(_1) } }
win_with_one_col_marked = ->(board) { board.transpose.any? { _all_marked.call(_1) } }
win_with_one_row_or_col_marked = ->(board) { win_with_one_col_marked.call(board) || win_with_one_row_marked.call(board) }
win_with_all_marked = ->(board) { board.all? { _all_marked.call(_1) } }

# rules_to_win_game
win_first_on_finish_a_board = ->(boards) { true }
win_last_on_finish_a_board = ->(boards) { boards.all?(&:finished?) }

# part 1
puts Game.new(win_with_one_row_or_col_marked, win_first_on_finish_a_board).play! == 58_412
puts Game.new(
  ->(a) { a.any?{_all_marked.(_1)} || a.transpose.any?{_all_marked.(_1)} },
  ->(_) { true }
).play! == 58_412
class WinWithOneRowOrCol; def self.call(a); a.any? { _1.all?(true) } || a.transpose.any? { _1.all?(true) } end end
class WinFirstBoard; def self.call(a); true end end
puts Game.new(WinWithOneRowOrCol, WinFirstBoard).play! == 58_412

# part 2
puts Game.new(win_with_one_row_or_col_marked, win_last_on_finish_a_board).play! == 10_030
puts Game.new(
  ->(a) { a.any?{_all_marked.(_1)} || a.transpose.any?{_all_marked.(_1)} },
  ->(a) { a.all?(&:finished?) }
).play! == 10_030
class WinLastBoard; def self.call(a); a.all?(&:finished?) end end
puts Game.new(WinWithOneRowOrCol, WinLastBoard).play! == 10_030

class WinLastBoardInstance; def call(a); a.all?(&:finished?) end end
puts Game.new(WinWithOneRowOrCol, WinLastBoardInstance.new).play! == 10_030

class WinLastBoardObject
  def self.call(arr)
    WinLastBoardObject.new(arr).call
  end

  def initialize(arr)
    @arr = arr
    putc '.'
    # something more....
  end

  def call
    @arr.all?(&:finished?)
  end
end
puts '', Game.new(WinWithOneRowOrCol, WinLastBoardObject).play! == 10_030
