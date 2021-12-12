# frozen_string_literal: true

class Cave < String
  def big?; upcase == self end
  def small?; downcase == self end
  def start?; self == 'start' end
  def end?; self == 'end' end
end

input = File.open('input').each_line(chomp: true)
ways = Hash.new { |h, k| h[k] = [] }
input.map { _1.split('-') }.each do |a, b|
  ways[a] << Cave.new(b)
  ways[b] << Cave.new(a)
end
ways.transform_values!(&:sort)

def ways.find_paths(rule, current = Cave.new('start'), path = [])
  path << current

  return if path.count(&:start?) > 1
  return path.join(',') if current.end?

  self[current].flat_map do |cave|
    next if rule.call(path, cave)

    find_paths(rule, cave, path.dup)
  end.compact
end

rule_part1 = ->(path, cave) { cave.small? && path.include?(cave) }
rule_part2 = ->(path, cave) { cave.small? && path.include?(cave) && path.select(&:small?).tally.values.any?(2) }

puts ways.find_paths(rule_part1).count == 3856
puts ways.find_paths(rule_part2).count == 116_692
