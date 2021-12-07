# frozen_string_literal: true

# size = wide * tall
#  150 =   25 * 6
# TRANSPARENT = '2'

# part 1
layers = open('input').read.scan(/.{150}/)
puts layers.min_by { _1.count('0') }.then { _1.count('1') * _1.count('2') } == 2_684

# part 2
image = '2' * 150
layers.each do |layer|
  150.times { |i| image[i] = layer[i] if image[i] == '2' && layer[i] != '2' }
end

puts image.tr('01', ' X').scan(/.{25}/)
# YGRYZ
