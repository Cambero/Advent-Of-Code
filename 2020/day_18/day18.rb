# frozen_string_literal: true

# https://en.wikipedia.org/wiki/Shunting-yard_algorithm
class Day18
  def initialize
    @expressions = File.open('input').readlines
    @precedence = Hash.new(0)
  end

  def part1
    @precedence['+'] = 1
    @precedence['*'] = 1
    @expressions.sum(&method(:evaluate))
  end

  def part2
    @precedence['+'] = 2
    @precedence['*'] = 1
    @expressions.sum(&method(:evaluate))
  end

  def apply_operator(operator, value1, value2)
    operator == '+' ? value1 + value2 : value1 * value2
  end

  def evaluate(tokens)
    values = []
    operators = []

    tokens.gsub(/\s/, '').chars.each do |token|
      case token
      when '+', '*'
        while @precedence[operators.last] >= @precedence[token]
          values << apply_operator(operators.pop, *values.pop(2))
        end
        operators << token
      when '('
        operators << token
      when ')'
        while (operator = operators.pop) != '('
          values << apply_operator(operator, *values.pop(2))
        end
      else
        values << token.to_i
      end
    end

    while (operator = operators.pop)
      values << apply_operator(operator, *values.pop(2))
    end

    values.first
  end
end
