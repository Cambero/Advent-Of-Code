# frozen_string_literal: true

class Day11
  DIRECTIONS = [[-1, 0], [-1, 1], [0, 1], [1, 1], [1, 0], [1, -1], [0, -1], [-1, -1]].freeze
  EMPTY = 'L'
  OCCUPIED = '#'
  FLOOR = '.'

  def initialize
    @grid = File.open('input').read.split("\n").map(&:chars)
    @bounds = (0...@grid.size)
    @can_change = @bounds.flat_map { |row| @bounds.map { |col| [row, col] } }
  end

  def part1
    @rules = { adjacent_only: true, max_neighbors: 4 }
    run!
  end

  def part2
    @rules = { adjacent_only: false, max_neighbors: 5 }
    run!
  end

  private

  def run!
    @can_change = next_round until @can_change.empty?
    @grid.flatten.count(OCCUPIED)
  end

  def next_round
    changed = []

    @can_change.each do |(row, col)|
      neighbors = occupied_seats(row: row, col: col)
      changed << [row, col] if empty_seat?(row, col) && neighbors.zero?
      changed << [row, col] if occupied_seat?(row, col) && neighbors >= @rules[:max_neighbors]
    end

    changed.each { |(row, col)| change_seat!(row, col) }
  end

  def occupied_seats(row:, col:)
    DIRECTIONS.count do |direction|
      occupied_direction?(row: row, col: col, direction: direction)
    end
  end

  def occupied_direction?(row:, col:, direction:)
    loop do
      row += direction.first
      col += direction.last

      return false unless in_bounds?(row, col)
      return true if occupied_seat?(row, col)
      return false if @rules[:adjacent_only] || seat?(row, col)
    end
  end

  def in_bounds?(row, col)
    @bounds.cover?(row) && @bounds.cover?(col)
  end

  def seat?(row, col)
    @grid[row][col] != FLOOR
  end

  def occupied_seat?(row, col)
    @grid[row][col] == OCCUPIED
  end

  def empty_seat?(row, col)
    @grid[row][col] == EMPTY
  end

  def change_seat!(row, col)
    @grid[row][col] = empty_seat?(row, col) ? OCCUPIED : EMPTY
  end
end
