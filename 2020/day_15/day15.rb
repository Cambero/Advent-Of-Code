# frozen_string_literal: true

class Day15
  def initialize
    @starting_numbers = File.open('input').read.split(',').map(&:to_i)
    @spoken_numbers = Hash.new { |h, k| h[k] = [] }
  end

  def part1
    play(2_020)
  end

  def part2
    play(30_000_000)
  end

  private

  def play(last_turn)
    @starting_numbers.each.with_index do |number, turn|
      @spoken_numbers[number] << turn
    end

    last_number_spoken = @starting_numbers.last

    (@starting_numbers.size...last_turn).each do |turn|
      last_spoken_turn, spoken_before_turn = @spoken_numbers[last_number_spoken]

      last_number_spoken = spoken_before_turn ? last_spoken_turn - spoken_before_turn : 0

      @spoken_numbers[last_number_spoken].unshift(turn)
    end

    last_number_spoken
  end
end
