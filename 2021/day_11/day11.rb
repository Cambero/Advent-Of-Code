# frozen_string_literal: true
Dumbo = Struct.new(:row, :col, :energy, keyword_init: true) do
  def flash!
    self.energy = 0
  end

  def flash?
    energy.zero?
  end

  def can_flash?
    energy > 9
  end

  def inc
    self.energy += 1
  end

  def flashed
    self.energy += 1 unless flash?
  end
end

class Grid < Array
  attr_reader :step, :total_flashes

  def initialize(filename = 'input')
    grid = File.open(filename).readlines(chomp: true).map.with_index do |row, y|
      row.chars.map.with_index do |value, x|
        Dumbo.new(row: y, col: x, energy: value.to_i)
      end
    end
    super(grid)
    @step = 0
    @total_flashes = 0
  end

  def next_step!
    @step += 1

    dumbos.each(&:inc)

    until dumbos_can_flash.empty?
      dumbos_can_flash.each do |dumbo|
        dumbo.flash!
        dumbos_adjacents(dumbo).each(&:flashed)
        @total_flashes += 1
      end
    end
  end

  def synchronize_flash!
    next_step! until all_flash?
  end

  def all_flash?
    flatten.all?(&:flash?)
  end

  def inbound?(y, x)
    (0..size - 1).include?(y) && (0..size - 1).include?(x)
  end

  def dumbos
    flatten
  end

  def dumbos_can_flash
    dumbos.select(&:can_flash?)
  end

  def dumbos_adjacents(dumbo)
    adjacents_points(dumbo).map { |y, x| self[y][x] }
  end

  def adjacents_points(dumbo)
    y = dumbo.row
    x = dumbo.col
    [
      [y - 1, x - 1], [y - 1, x], [y - 1, x + 1],
      [y, x - 1], [y, x + 1],
      [y + 1, x - 1], [y + 1, x], [y + 1, x + 1]
    ].select { inbound?(_1, _2) }
  end
end

filename = 'input'
grid = Grid.new(filename)

100.times { grid.next_step! }
puts grid.total_flashes == (filename == 'input' ? 1627 : 1656)

grid.synchronize_flash!
puts grid.step == (filename == 'input' ? 329 : 195)
