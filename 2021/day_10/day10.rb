# frozen_string_literal: true

SCORES = {
  '(' => 1, '[' => 2, '{' => 3, '<' => 4,
  ')' => 3, ']' => 57, '}' => 1_197, '>' => 25_137
}.freeze

lines = open('input').readlines(chomp: true)

delete_valid_chunks = ->(line) { true while %w(() [] {} <>).any? { |chunk| line.gsub!(chunk, '') } }
get_first_close_chunk = ->(line) { line.delete('([{<')[0] }

corrupted, incomplete = lines.each(&delete_valid_chunks).partition(&get_first_close_chunk)

score_for_corrupted_line = ->(line) { SCORES[get_first_close_chunk.call(line)] }
puts corrupted.sum(&score_for_corrupted_line) == 399_153

score_for_incomplete_line = ->(line) { line.reverse.each_char.map { SCORES[_1] }.reduce(&-> { _1 * 5 + _2 }) }
puts incomplete.map(&score_for_incomplete_line).sort[incomplete.size / 2] == 2_995_077_699
