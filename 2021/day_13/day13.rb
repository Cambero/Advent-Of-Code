# frozen_string_literal: true

Dot = Struct.new(:x, :y) do
  def fold(axis, position)
    send("#{axis}=", position - (send(axis) - position)) if send(axis) >= position
  end
end

dots, folds = File.read('input').split("\n\n")
origami = dots.split("\n").map { _1.split(',').map(&:to_i) }.map { Dot.new _1, _2 }

def origami.show(empty = '.')
  puts Array.new(map(&:y).max + 1) { empty * (map(&:x).max + 1) }.tap { |arr| each { |dot| arr[dot.y][dot.x] = '#' } }
end

def origami.fold(fold)
  axis, position = fold.split('=')
  each { |dot| dot.fold(axis, position.to_i) }
end

folds.split("\n").map { _1.split.last }.each_with_index do |fold, i|
  origami.fold(fold)
  puts origami.uniq.count == 795 if i.zero?
end

origami.show(' ') # CEJKLUGJ
