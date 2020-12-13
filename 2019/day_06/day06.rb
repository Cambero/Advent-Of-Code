# frozen_string_literal: true

class Day06
  def initialize
    @orbits = File.open('input').read
                  .split("\n")
                  .map { |line| line.split(')').reverse }
                  .to_h
  end

  def part1
    @orbits.keys.sum { |object| path_for(object).size }
  end

  def part2
    san_path = path_for('SAN')
    you_path = path_for('YOU')
    common_path = path_for('SAN') & path_for('YOU')

    (san_path + you_path - common_path).size
  end

  private

  def path_for(object)
    path = []
    path << object while object = @orbits[object]
    path
  end
end
