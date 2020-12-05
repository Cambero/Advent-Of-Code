# frozen_string_literal: true

class Day05
  attr_reader :passes

  def initialize
    @passes = open('input').read.split("\n")
  end

  def part1
    passes.map { |pass| seat_id(pass) }.max
  end

  def part2
    seat_ids = passes.map { |pass| seat_id(pass) }
    (Range.new(*seat_ids.minmax).to_a - seat_ids).first
  end

  private

  def seat_id(pass)
    pass[0, 7].tr('FB', '01').to_i(2) * 8 + pass[7, 3].tr('LR', '01').to_i(2)
  end
end
