# frozen_string_literal: true

class Pair < Array
  def initialize(input)
    super(input.map { %w[Array Pair].include?(_1.class.name) ? Pair.new(_1) : _1 })
  end

  def magnitude
    3 * first.magnitude + 2 * last.magnitude
  end

  def +(other)
    Pair.new([self, other]).reduced
  end

  def reduced
    true while explode || split

    self
  end

  def explode
    # next_if_array = ->(pair) { pair.is_a?(Pair) }
    binary_enum = Enumerator.produce('0') { (_1.to_i(2) + 1).to_s(2) }

    each_with_index do |l1, i1|
      next unless l1.is_a?(Pair)

      l1.each_with_index do |l2, i2|
        next unless l2.is_a?(Pair)

        l2.each_with_index do |l3, i3|
          next unless l3.is_a?(Pair)

          l3.each_with_index do |l4, i4|
            next unless l4.is_a?(Pair)

            return explode!(i1, i2, i3, i4, l4)
          end
        end
      end
    end
    false
  end

  def split
    each_with_index do |l1, i1|
      if l1.is_a?(Integer)
        next if l1 < 10

        self[i1] = Pair.new([self[i1] / 2, (self[i1] / 2.0).round])
        return true
      end
      l1.each_with_index do |l2, i2|
        if l2.is_a?(Integer)
          next if l2 < 10

          self[i1][i2] = Pair.new([self[i1][i2] / 2, (self[i1][i2] / 2.0).round])
          return true
        end

        l2.each_with_index do |l3, i3|
          if l3.is_a?(Integer)
            next if l3 < 10

            self[i1][i2][i3] = Pair.new([self[i1][i2][i3] / 2, (self[i1][i2][i3] / 2.0).round])
            return true
          end

          l3.each_with_index do |l4, i4|
            if l4.is_a?(Integer)
              next if l4 < 10

              self[i1][i2][i3][i4] = Pair.new([self[i1][i2][i3][i4] / 2, (self[i1][i2][i3][i4] / 2.0).round])
              return true
            end
          end
        end
      end
    end
    false
  end

  private

  def explode!(i1, i2, i3, i4, l4)
    index = [i1, i2, i3, i4].join.to_i(2)

    explode_on(index - 1, l4.first) if index.positive?
    explode_on(index + 1, l4.last) if index < 15

    self[i1][i2][i3][i4] = 0
    return true
  end

  def explode_on(index, value)
    indexes = index.to_s(2).rjust(4, '0').chars.map(&:to_i)
    side = self
    idx = 0
    4.times do |i|
      if side[indexes[i]].is_a?(Pair)
        side = side[indexes[i]]
      else
        idx = indexes[i]
        break
      end
    end

    side[idx] += value
  end
end


pairs = File.open('input').each_line(chomp: true).map { |input| Pair.new(eval(input)) }

# part 1
pair = pairs[0]

puts pair.to_s
pairs[1..].each { pair += _1 }
puts pair.magnitude == 3793

# part 2
magnitudes = pairs.flat_map do |p1|
  (pairs - [p1]).map do |p2|
    (p1 + p2).magnitude
  end
end

puts magnitudes.max == 4695

