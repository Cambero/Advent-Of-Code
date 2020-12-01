# frozen_string_literal: true

class Day02
  def initialize
    @program = open('input').read.chomp.split(',').map(&:to_i)
  end

  def part1
    exec(12, 2)
  end

  def part2
    (0..99).each do |noun|
      (0..99).each do |verb|
        return 100 * noun + verb if exec(noun, verb) == 19_690_720
      end
    end
  end

  private

  def exec(noun, verb)
    program = @program.dup
    program[1] = noun
    program[2] = verb

    program.each_slice(4) do |op, a, b, r|
      return program[0] if op == 99

      program[r] = (op == 1 ? program[a] + program[b] : program[a] * program[b])
    end
  end
end
