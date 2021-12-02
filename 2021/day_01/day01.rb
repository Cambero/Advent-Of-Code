# frozen_string_literal: true

depths = File.open('input').readlines.map(&:to_i)

increments = -> (depths) { depths.each_cons(2).count { |a, b| b > a } }
puts increments.(depths) == 1292
# 1292

sliding_windows = depths.each_cons(3).map(&:sum)
puts increments.(sliding_windows) == 1262
# 1262
