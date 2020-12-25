# frozen_string_literal: true

class Day24
  POSITIONS = { se: [1, 1], sw: [1, -1], nw: [-1, -1], ne: [-1, 1], w: [0, -2], e: [0, 2] }.freeze
  BLACK = true
  WHITE = false

  def initialize
    @grid = {}
    File.open('input').read.split("\n").each do |directions|
      position = position_of_tile(directions)
      @grid[position] = !@grid[position]
    end
  end

  def part1
    @grid.values.count(BLACK)
  end

  def part2
    100.times do
      new_grid = {}
      @grid.each_key do |(row, col)|
        [[row, col], *neighbors_coordinates(row, col)].each do |y, x|
          new_grid[[y, x]] = BLACK if position_black?(y, x)
        end
      end
      @grid = new_grid
    end

    @grid.values.count(BLACK)
  end

  def neighbors_coordinates(row, col)
    POSITIONS.values.map { |y, x| [row + y, col + x] }
  end

  private

  def position_black?(row, col)
    black_tiles = @grid.values_at(*neighbors_coordinates(row, col)).count(BLACK)

    keep_black = @grid[[row, col]] && [1, 2].include?(black_tiles)
    change_to_black = !@grid[[row, col]] && black_tiles == 2

    keep_black || change_to_black
  end

  def position_of_tile(directions)
    position = [0, 0]
    POSITIONS.each do |direction, (y, x)|
      repeat = directions.scan(Regexp.new(direction.to_s)).size
      position = [position.first + y * repeat, position.last + x * repeat]
      directions.gsub!(Regexp.new(direction.to_s), '')
    end
    position
  end
end
