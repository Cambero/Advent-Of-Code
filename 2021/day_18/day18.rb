# frozen_string_literal: true

class Array
  def magnitude
    3 * first.magnitude + 2 * last.magnitude
  end
end

# [number, nested_count]
def to_nail_number(str)
  snail_number = []
  open = 0
  str.each_char do |c|
    snail_number << [c.to_i, open] if c =~ /\d/
    open += 1 if c == '['
    open -= 1 if c == ']'
  end
  snail_number
end

def sum_nail(number, str)
  # add number, +1 nested & reduce
  number.push(*to_nail_number(str))
  number.each { _1[1] += 1 }
  reduce(number)
end

def reduce(number)
  true while explode!(number) || split!(number)
end

def explode!(number)
  return false unless (to_explode = number.find { |_, nested| nested > 4 })

  # sum left and right
  index = number.index(to_explode)
  number[index - 1][0] += to_explode.first if index.positive?
  number[index + 2][0] += number[index + 1].first if number[index + 2]

  # replace pair by 0 => -1 nested
  number.delete_at(index + 1)
  number[index][0] = 0
  number[index][1] -= 1
end

def split!(number)
  return false unless (to_split = number.find { |value, _| value > 9 })

  index = number.index(to_split)

  # insert new pair with +1 nested
  number.insert(index + 1,
                [to_split[0] / 2, to_split[1] + 1], [(to_split[0] / 2.0).round, to_split[1] + 1])

  # delete splited
  number.delete_at(index)
end


def magnitude(number)
  4.downto(1) do |nested|
    (number.size - 1).downto(1) do |i|
      next unless number[i].last == nested

      number[i - 1][0] = [number[i - 1][0], number[i][0]].magnitude
      number[i - 1][1] -= 1

      number.delete_at(i)
    end
  end
  number.flatten.first
end


pairs = File.open('input').each_line(chomp: true).to_a

# part 1
number = to_nail_number(pairs[0])
pairs[1..].each do |pair|
  sum_nail(number, pair)
end
puts magnitude(number) == 3793

# part 2
magnitudes = []
pairs.each do |p1|
  (pairs - [p1]).each do |p2|
    number = to_nail_number(p1)
    sum_nail(number, p2)
    magnitudes << magnitude(number)
  end
end
puts magnitudes.max == 4695

