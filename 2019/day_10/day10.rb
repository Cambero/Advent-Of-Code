# frozen_string_literal: true
class Point < Array
  def x; first  end
  def y; last end
end

def angle_between(from, to)
  # Positivo si el destino esta a la derecha, es decir, aumenta x
  dx = to.x - from.x
  # Positivo si el destino esta arriba, es decir, disminuye -y
  dy = from.y - to.y
  gcd = dx.gcd(dy)
  dx /= gcd
  dy /= gcd
  angle_by_clockwise(dx, dy)
end

def angle_by_clockwise(x, y)
  # atan2(y, x) => change x, y to use clockwise, otherwise 0 degrees is like 3:00 on the clock
  ((Math.atan2(x, y) * (180 / Math::PI) + 360) % 360).round(6)
end

# {[position asteroid base][angle] => [asteroids in line (only closest is visible)]}
# grid[base_position][angle] << [y,x]
@grid = Hash.new { |h, k| h[k] = Hash.new { |h, k| h[k] = [] } }

# Set Asteroids on grid
open('input').read.split("\n").each_with_index do |row, y|
  row.gsub(/#/)
     .map { Regexp.last_match.begin(0) }
     .each { |x| @grid[Point.new([x, y])] }
end

# Set angles for lines of sight, with asteroids unordered in that line of sight
# only the closest asteroid is visible
@grid.each_key do |from|
  (@grid.keys - [from]).each do |to|
    @grid[from][angle_between(from, to)] << to
  end
end

# Place the station on the best location
best_location, visible = @grid.max_by { |_, v| v.count }.then { [_1, _2.size] }

puts visible == 253

@station = @grid[best_location]
# In each line of sight, sort asteroids by distance (only first is visible)
@station.each_value do |asteroids|
  asteroids.sort_by! { |x, y| (best_location.x - x).abs + (best_location.y - y) }
end


vaporized = []
catch :asteroid do
  until @station.keys.empty?
    @station.keys.sort.each do |angle|
      vaporized << @station[angle].shift
      @station.delete(angle) if @station[angle].empty?

      throw :asteroid if vaporized.size == 200
    end
  end
end

puts vaporized.last.to_s == '[8, 15]'
puts vaporized.last.x * 100 + vaporized.last.y == 815
