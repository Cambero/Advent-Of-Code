# frozen_string_literal: true

class Day14
  MASK_LENGTH = 36

  def initialize
    @code = File.open('input').read.split("\n")
    @memory = {}
    @mask = ''
  end

  def part1
    run do |address, value|
      @memory[address] = apply_mask(value, ignore: 'X').to_i(2)
    end
  end

  def part2
    run do |address, value|
      binary_direction = apply_mask(address, ignore: '0')

      %w[0 1].repeated_permutation(binary_direction.count('X')).each do |combination|
        masked_address = binary_direction.gsub('X', '%s') % combination

        @memory[masked_address] = value
      end
    end
  end

  private

  def run(&block)
    @code.each do |line|
      next @mask = line.split(' = ').last if line.start_with?('mask')

      address, value = line.scan(/mem\[(\d+)\] = (\d+)/).first.map(&:to_i)

      yield address, value
    end

    @memory.values.sum
  end

  def apply_mask(value, ignore:)
    value = value.to_i.to_s(2).rjust(MASK_LENGTH, '0')
    MASK_LENGTH.times do |i|
      value[i] = @mask[i] if @mask[i] != ignore
    end
    value
  end
end
