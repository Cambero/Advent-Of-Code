# frozen_string_literal: true

# template = 'SB'
# rules = [SB -> B, BB -> S, BS -> B]
# to_pairs = { 'SB' => ['SB' 'BB'], 'BB' => ['BS, SB'], 'BS' => ['BB', 'BS'] }
# => count_pairs by step
#       step 0: SB         count_pairs: { SB: 1 }
# after step 1: SBB        count_pairs: { SB: 1, BB: 1 }
# after step 2: SBBSB      count_pairs: { SB: 2, BB: 1, BS: 1 }
# after step 3: SBBSBBSBB  count_pairs: { SB: 3, BB: 3, BS: 2 }
# => count occurrences of the first letter for each count key + 1 last letter of template
# count: { SB: 3, BB: 3, BS: 2} => letters = { S: 3, B: 3+2 }
# + 1 last letter of template
# letters['B'] += 1

template, rules = File.read('input').split("\n\n")
to_pairs = {}
rules.split("\n").map { _1.split(' -> ') }.each do |k, v|
  to_pairs[k] = [k[0] + v, v + k[1]]
end

count_pairs = Hash.new(0)
count_letters = Hash.new(0)
template.chars.each_cons(2) { count_pairs[_1.join] += 1 }

40.times do
  count_pairs.dup.each do |pair, count|
    # add news pairs
    count_pairs[to_pairs[pair].first] += count
    count_pairs[to_pairs[pair].last] += count
    # less current pair
    count_pairs[pair] -= count
  end
end

# +1 last letter of template
count_pairs[template[-1]] = 1

count_pairs.each { |k, v| count_letters[k[0]] += v }
puts count_letters.values.minmax.inject(:-).abs == 8_336_623_059_567
