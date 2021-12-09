# frozen_string_literal: true

class SignalPattern < String
  SEGMENTS = 'abcdefg'

  DIGIT_TO_SEGMENTS = {
    0 => 'abcefg',
    1 => 'cf',
    2 => 'acdeg',
    3 => 'acdfg',
    4 => 'bcdf',
    5 => 'abdfg',
    6 => 'abdefg',
    7 => 'acf',
    8 => 'abcdefg',
    9 => 'abcdfg'
  }.freeze

  def self.each_digit_ordered_by_easiest(&block)
    # easiest if is the only pattern with that size
    digits_by_pattern_size = Hash.new { |h, k| h[k] = [] }
    DIGIT_TO_SEGMENTS.each { |digit, pattern| digits_by_pattern_size[pattern.size] << digit }

    digits_by_pattern_size.sort_by { |size, digits| [digits.size, size] }
                          .map(&:last)
                          .flatten
                          .each(&block)
  end

  def self.segments
    SignalPattern.new(SEGMENTS)
  end

  def self.digit(segment)
    DIGIT_TO_SEGMENTS.invert[segment]
  end

  def self.pattern(digit)
    DIGIT_TO_SEGMENTS[digit]
  end

  def self.each_segment_for(digit, &block)
    DIGIT_TO_SEGMENTS[digit].each_char(&block)
  end

  def self.each_segment_unsued_for(digit, &block)
    SEGMENTS.delete(DIGIT_TO_SEGMENTS[digit]).each_char(&block)
  end

  def decode(wires)
    decoded_pattern = gsub(/./, wires).chars.sort.join
    DIGIT_TO_SEGMENTS.invert[decoded_pattern]
  end

  def wire!(signal)
    delete!("^#{signal}")
  end

  def unwire!(signal)
    delete!(signal)
  end

  def valid_wire_for_digit?(digit, wires)
    wires_segments_with_counts = DIGIT_TO_SEGMENTS[digit].chars.map { |segment| wires[segment] }.tally

    wires_segments_with_counts.all? { |segments, count| valid_segments?(segments, count) }
  end

  def valid_segments?(segments, count)
    if count == segments.size
      # [['ab'], ['ab']] => Should include a & b
      # example: 'ab'.delete('abcef') => empty? => include a & b
      segments.delete(self).empty?
    else
      # example: 'acefg'.delete(^'ab') = 'a' => !empty? => include almost one
      delete("^#{segments}").size.positive?
    end
  end
end

class Entry < Array
  def initialize(str)
    super(str.delete('|').split.map { SignalPattern.new(_1) })
    @wires = Hash.new { _1[_2] = SignalPattern.segments }
  end

  def signals
    self[0...-4]
  end

  def output
    last(4)
  end

  def run
    wire!
    decode_outputs
  end

  def decode_outputs
    output.map { |o| o.decode(@wires.invert) }.join.to_i
  end

  def each_signal_that_can_be(digit, &block)
    signals.select { _1.size == SignalPattern.pattern(digit).size }.each(&block)
  end

  private

  def wire!
    SignalPattern.each_digit_ordered_by_easiest do |digit|
      each_signal_that_can_be(digit) do |signal|
        next unless signal.valid_wire_for_digit?(digit, @wires)

        SignalPattern.each_segment_for(digit) { |segment| @wires[segment].wire!(signal) }
        SignalPattern.each_segment_unsued_for(digit) { |segment| @wires[segment].unwire!(signal) }
      end
    end
  end
end

entries = File.open('input').readlines.map { Entry.new(_1) }
# entries = [Entry.new("acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf")]
# part 1
puts entries.sum { |entry| entry.output.map(&:size).count { [2, 4, 3, 7].include?(_1) } } == 301

# part 2
puts entries.sum(&:run) == 908_067


#   0:      1:      2:      3:      4:
#  aaaa    ....    aaaa    aaaa    ....
# b    c  .    c  .    c  .    c  b    c
# b    c  .    c  .    c  .    c  b    c
#  ....    ....    dddd    dddd    dddd
# e    f  .    f  e    .  .    f  .    f
# e    f  .    f  e    .  .    f  .    f
#  gggg    ....    gggg    gggg    ....
#
#   5:      6:      7:      8:      9:
#  aaaa    aaaa    aaaa    aaaa    aaaa
# b    .  b    .  .    c  b    c  b    c
# b    .  b    .  .    c  b    c  b    c
#  dddd    dddd    ....    dddd    dddd
# .    f  e    f  .    f  e    f  .    f
# .    f  e    f  .    f  e    f  .    f
#  gggg    gggg    ....    gggg    gggg
