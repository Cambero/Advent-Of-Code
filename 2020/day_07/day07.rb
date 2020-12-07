# frozen_string_literal: true

class Day07
  def initialize
    @rules = {}

    open('input').read.split("\n").map do |rule|
      container, contents = rule.split(' bags contain ')
      contents = contents.scan(/(\d+) (\w+ \w+) bag/).flat_map { |n, color| [color] * n.to_i }

      @rules[container] = contents
    end
  end

  def part1
    @rules.each_key.count { |bag| children(bag, true).include?('shiny gold') }
  end

  def part2
    children('shiny gold', false).size
  end

  private

  def children(bag, uniq)
    @rules[bag] +
      (uniq ? @rules[bag].uniq : @rules[bag]).map { |child| children(child, uniq) }.flatten
  end
end
