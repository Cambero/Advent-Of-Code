# frozen_string_literal: true

class Range
  def &(other)
    [min, other.min].max .. [max, other.max].min
  end
end

class Cube
  attr_reader :x, :y, :z

  def self.from_string(step)
    /(\w+) x=(.+),y=(.+),z=(.+)$/ =~ step

    Cube.new *[$2, $3, $4].map { |range| eval range }, $1 == 'on'
  end

  def initialize(x, y, z, on = false)
    @on = on
    @x = x
    @y = y
    @z = z
  end

  def &(b)
    x = @x & b.x
    y = @y & b.y
    z = @z & b.z
    Cube.new(x, y, z) unless [x, y, z].any? { _1.size.zero? }
  end

  def on?  = @on
  def size = @x.size * @y.size * @z.size
end

cubes = File.open('input').readlines(chomp: true).map { Cube.from_string(_1) }
cubes_on = []
cubes_off = []

cubes.each do |cube|
  turned_on_or_repeated = cubes_off.map { _1 & cube }.compact
  turned_off_or_repeated = cubes_on.map { _1 & cube }.compact

  cubes_on += turned_on_or_repeated
  cubes_off += turned_off_or_repeated

  cubes_on << cube if cube.on?
end

puts cubes_on.sum(&:size) - cubes_off.sum(&:size) == 1_262_883_317_822_267
