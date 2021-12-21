# frozen_string_literal: true

class Probe
  attr_reader :x, :y, :ax, :ay, :vx, :vy, :trajectory

  def initialize(vx, vy, ax, ay)
    @trajectory = []
    @vx, @vy = vx, vy
    @ax, @ay = ax, ay
    @x = @y = 0
  end

  def fire!
    next_step while !inside? && !passed? && !unreachable?
    self
  end

  def inside?
    ax.include?(x) && ay.include?(y)
  end

  def passed?
    ay.min > y ||
      ax.max < x && vx.positive? ||
      ax.min > x && vx.negative?
  end

  def unreachable?
    vx.zero? && !ax.include?(x)
  end

  def next_step
    move
    update_velocity
    @trajectory.push(@x, @y)
  end

  def move
    @x += vx
    @y += vy
  end

  def update_velocity
    @vx -= 1 if vx.positive?
    @vx += 1 if vx.negative?
    @vy -= 1
  end
end

input = File.read('input')
# input = 'target area: x=20..30, y=-10..-5'

area_x, area_y = input.scan(/-?\d+/).map(&:to_i).each_slice(2).map { Range.new(_1, _2) }

min_vx = (1..).find { |n| (1..n).sum >= area_x.min }
range_of_vx = (min_vx..area_x.max)
range_of_vy = (area_y.min..area_y.min.abs)

probes = range_of_vy.flat_map do |vy|
  range_of_vx.map do |vx|
    probe = Probe.new(vx, vy, area_x, area_y)
    probe if probe.dup.fire!.inside?
  end.compact
end

# part 1
puts (1..probes.map(&:vy).max).sum == 8646

# part 2
puts probes.count == 5945
