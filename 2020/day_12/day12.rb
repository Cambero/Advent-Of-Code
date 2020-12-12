# frozen_string_literal: true

class Day12
  def initialize
    @instructions = File.open('input').read.split("\n").map { [_1[0], _1[1..].to_i] }
    @ship = { y: 0, x: 0 }
  end

  def part1
    @waypoint = { y: 0, x: 1 }
    run(cardinal_move_ship: true)
  end

  def part2
    @waypoint = { y: -1, x: 10 }
    run(cardinal_move_ship: false)
  end

  private

  def run(cardinal_move_ship:)
    cardinal_movement = cardinal_move_ship ? @ship : @waypoint

    @instructions.each do |(action, value)|
      case action
      when 'N' then cardinal_movement[:y] -= value
      when 'S' then cardinal_movement[:y] += value
      when 'E' then cardinal_movement[:x] += value
      when 'W' then cardinal_movement[:x] -= value
      when 'L' then (value / 90).times { @waypoint[:y], @waypoint[:x] = -@waypoint[:x], @waypoint[:y] }
      when 'R' then (value / 90).times { @waypoint[:y], @waypoint[:x] = @waypoint[:x], -@waypoint[:y] }
      when 'F'
        @ship[:y] += value * @waypoint[:y]
        @ship[:x] += value * @waypoint[:x]
      end
    end

    @ship[:y].abs + @ship[:x].abs
  end
end
