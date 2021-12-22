# frozen_string_literal: true

class TrenchMap < Hash
  def initialize(input)
    super()
    @enhancement, image = input.split("\n\n")

    image.split("\n").each_with_index do |row, y|
      row.each_char.with_index do |value, x|
        self[[x,y]] = (value == '#' ? 1 : 0)
      end
    end

    @infinite = 0
  end

  def show
    puts range_of(:last).map { |y| range_of(:first).map { |x| self[[x, y]] || 0 }.join.tr('01', ' #').to_s }
  end

  def enhancing
    replace(enhanced)

    # if enhancement[0] is light => infinite change between 0 & 1
    @infinite ^= 1 if @enhancement[0] == '#'
  end

  private

  def adjacent(x, y)
    [
      [x - 1, y - 1], [x, y - 1], [x + 1, y - 1],
      [x - 1, y    ], [x, y    ], [x + 1, y    ],
      [x - 1, y + 1], [x, y + 1], [x + 1, y + 1],
    ].map { self[_1] || @infinite }.join.to_i(2)
  end

  def enhanced
    range_of(:last).flat_map do |y|
      range_of(:first).map do |x|
        [[x,y], (@enhancement[(adjacent(x,y))] == '#' ? 1 : 0)]
      end
    end.to_h
  end

  def range_of(position)
    keys.map(&position).minmax.then { Range.new(_1 - 1, _2 + 1) }
  end
end

example = TrenchMap.new(File.open('input_example').read)
example.show
2.times { example.enhancing }
puts example.values.count(1) == 35
48.times { example.enhancing }
puts example.values.count(1) == 3_351

tm = TrenchMap.new(File.open('input').read)
2.times { tm.enhancing }
puts tm.values.count(1) == 5081
48.times { tm.enhancing }
puts tm.values.count(1) == 15_088

