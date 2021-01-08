# frozen_string_literal: true

class Day25
  MOD = 20_201_227
  attr_reader :card_public_key, :door_public_key

  def initialize
    @card_public_key, @door_public_key = File.readlines('input').map(&:to_i)
  end

  def part1
    card_loop_size = loop_size_for(card_public_key)
    door_loop_size = loop_size_for(door_public_key)

    encryption_key1 = card_loop_size.times.reduce(1) { |val| transform(val, door_public_key) }
    encryption_key2 = door_loop_size.times.reduce(1) { |val| transform(val, card_public_key) }

    puts encryption_key1 == encryption_key2
    encryption_key1
  end

  private

  def transform(value, subject_number)
    value * subject_number % MOD
  end

  def loop_size_for(public_key)
    value = 1
    subject_number = 7
    (1..).each do |size|
      value = transform(value, subject_number)
      return size if value == public_key
    end
  end
end

puts Day25.new.part1 == 6_198_540
