# frozen_string_literal: true

class Day20
  def initialize(input = nil)
    @tiles = File.open('input')
                 .read
                 .split("\n\n")
                 .map { |tiles| tiles.split("\n") }
                 .map { |tile| [tile.shift.scan(/\d+/).first.to_i, tile.map(&:chars)] }
                 .to_h
  end

  def part1
    corner_tiles.inject(:*)
  end

  def part2
    _monsters, image = search_monster(reassembled)

    image.flatten.count('#')
  end

  private

  def search_monster(image)
    monster_pattern = %w[..................#. #....##....##....### .#..#..#..#..#..#...]
    monster_index = monster_pattern.map do |row|
      row.chars
         .filter_map
         .with_index { |c, i| i if c == '#' }
    end

    monsters = 0
    rotate_and_flip_image(image).each do |img|

      img.each_cons(3).with_index do |lines, line_number|
        # next if lines no match with monster pattern
        b = lines[1].join =~ (Regexp.new(monster_pattern[1]))
        c = lines[2].join =~ (Regexp.new(monster_pattern[2]))

        next unless b & c

        # started index to search match
        base = [b, c].max
        match_count = []
        monster_index.each_with_index do |line_monster, line_index|
          line_monster.each do |char_offset|
            match_count << (lines[line_index][base + char_offset] == '#')
          end
        end

        # false positive
        next unless match_count.all?

        # found, replace with 'O'
        monsters += 1
        monster_index.each_with_index do |line_monster, line_index|
          line_monster.each do |char_offset|
            lines[line_index][base + char_offset] = 'O'
          end
        end

        # Replace in image
        img[line_number + 0] = lines[0]
        img[line_number + 1] = lines[1]
        img[line_number + 2] = lines[2]

        # search for other monster in the same lines
        redo
      end

      return [monsters, img] if monsters.positive?
    end
  end

  def unique_border?(border)
    unique_borders.include?(border)
  end

  def border_top(tile)
    tile.first.join
  end

  def border_bottom(tile)
    tile.last.join
  end

  def border_left(tile)
    tile.transpose.first.join
  end

  def border_right(tile)
    tile.transpose.last.join
  end

  def all_borders
    @borders ||= @tiles.transform_values { |tile| borders_for_tile(tile) }
  end

  def unique_borders
    @unique_borders ||= all_borders.values.flatten.tally.filter_map { |border, repeat| border if repeat == 1 }
  end

  def corner_tiles
    @corner_tiles ||= all_borders.keys.select { |id| unique_borders_for_tile(id).size == 4 }
  end

  def bound_tiles
    @bound_tiles ||= all_borders.keys.select { |id| unique_borders_for_tile(id).size == 2 }
  end

  def internal_tiles
    @internal_tiles ||= all_borders.keys.select { |id| unique_borders_for_tile(id).empty? }
  end

  def unique_borders_for_tile(id)
    (all_borders[id] & unique_borders)
  end

  def rotate_and_flip_image(image)
    [
      image,
      image.transpose,
      image.transpose.map(&:reverse).transpose,
      image.map(&:reverse).transpose
    ].flat_map { |img| [img, img.map(&:reverse)] }
  end

  def borders_for_tile(tile)
    [tile, tile.transpose]
      .flat_map { |t| [t.first, t.last, t.first.reverse, t.last.reverse] }
      .map(&:join)
  end

  def reassembled
    side = Math.sqrt(@tiles.size).to_i
    sorted_tiles = Array.new(side) { Array.new(side) }
    tile_ids = @tiles.keys

    side.times do |row|
      side.times do |col|
        tile_ids.each do |tile_id|
          break if sorted_tiles[row][col]

          rotate_and_flip_image(@tiles[tile_id]).each do |tile|
            break if sorted_tiles[row][col]

            border_top = row.zero? ? unique_border?(border_top(tile)) : true
            border_bottom = row == side - 1 ? unique_border?(border_bottom(tile)) : true
            border_left = col.zero? ? unique_border?(border_left(tile)) : true
            border_right = col == side - 1 ? unique_border?(border_right(tile)) : true
            next unless [border_top, border_bottom, border_left, border_right].all?

            fit_border_top = row.positive? ? border_top(tile) == border_bottom(sorted_tiles[row - 1][col]) : true
            fit_border_left = col.positive? ? border_left(tile) == border_right(sorted_tiles[row][col - 1]) : true
            next unless [fit_border_top, fit_border_left].all?

            sorted_tiles[row][col] = tile
            tile_ids.delete(tile_id)
          end
        end
      end
    end

    # image without borders
    image = []
    sorted_tiles.each do |row|
      (1..8).each do |i|
        image << row.flat_map { |tile| tile[i][1..8] }
      end
    end

    image
  end
end

puts Day20.new.part1 == 7_492_183_537_913
puts Day20.new.part2 == 2_323
