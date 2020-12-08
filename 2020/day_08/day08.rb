# frozen_string_literal: true

class Day08
  def initialize
    @instructions = open('input').read.split("\n")
  end

  def part1
    boot(@instructions).first
  end

  def part2
    (0..).each do |i|
      next if @instructions[i].split(' ').first == 'acc'

      code = Marshal.load(Marshal.dump(@instructions))
      code[i].sub!(/nop|jmp/, { 'nop' => 'jmp', 'jmp' => 'nop' })
      acc, ip = boot(code)
      return acc if ip >= @instructions.size
    end
  end

  private

  def boot(code)
    acc = 0
    ip = 0
    while code[ip]
      operation, argument = code[ip].split(' ')
      code[ip] = nil
      acc += argument.to_i if operation == 'acc'
      ip += (operation == 'jmp' ? argument.to_i : 1)
    end

    [acc, ip]
  end
end
