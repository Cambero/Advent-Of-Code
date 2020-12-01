# frozen_string_literal: true

class Day05
  attr_reader :program

  def initialize
    @sourcecode = open('input').read.chomp.split(',').map(&:to_i)
  end

  def part1
    run(1)
  end

  def part2
    run(5)
  end

  private

  def run(input)
    @program = @sourcecode.dup
    @pointer = 0

    diagnostic_code = nil

    loop do
      next_instruction

      case operation
      when 1 then sum
      when 2 then multiply
      when 3 then input(input)
      when 4 then diagnostic_code = output
      when 5 then jump_if_true
      when 6 then jump_if_false
      when 7 then less_than
      when 8 then equals
      when 99 then return diagnostic_code
      end
    end
  end

  def next_instruction
    @instruction = program[@pointer].to_s.rjust(4, '0')
  end

  def operation
    @instruction[-2..].to_i
  end

  def value_for(parameter, mode)
    mode.zero? ? program[parameter] : parameter
  end

  def value_for_first_param
    value_for(program[@pointer + 1], @instruction[-3].to_i)
  end

  def value_for_second_param
    value_for(program[@pointer + 2], @instruction[-4].to_i)
  end

  def sum
    program[program[@pointer + 3]] = value_for_first_param + value_for_second_param
    @pointer += 4
  end

  def multiply
    program[program[@pointer + 3]] = value_for_first_param * value_for_second_param
    @pointer += 4
  end

  def input(value)
    program[program[@pointer + 1]] = value
    @pointer += 2
  end

  def output
    value_for_first_param.tap do
      puts _1
      @pointer += 2
    end
  end

  def jump_if_true
    @pointer = value_for_first_param.zero? ? @pointer + 3 : value_for_second_param
  end

  def jump_if_false
    @pointer = value_for_first_param.zero? ? value_for_second_param : @pointer + 3
  end

  def less_than
    program[program[@pointer + 3]] = value_for_first_param < value_for_second_param ? 1 : 0
    @pointer += 4
  end

  def equals
    program[program[@pointer + 3]] = value_for_first_param == value_for_second_param ? 1 : 0
    @pointer += 4
  end
end
