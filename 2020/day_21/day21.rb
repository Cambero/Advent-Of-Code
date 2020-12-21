# frozen_string_literal: true

class Day21
  def initialize
    @foods = File.open('input')
                 .read
                 .split("\n")
                 .map { |line| line.tr(',()', '').split(' contains ') }
                 .map { |food| food.map(&:split) }

    @ingredient_allergen = {}
    @possibly = Hash.new { |h, k| h[k] = [] }
    @foods.each do |ingredients, allergens|
      ingredients.each do |ingredient|
        @possibly[ingredient] += allergens
      end
    end
    @possibly.transform_values!(&:tally)
  end

  def part1
    build_ingredient_allergen!

    @foods.flat_map(&:first).count { |ingredient| @possibly.keys.include?(ingredient) }
  end

  def part2
    build_ingredient_allergen!

    @ingredient_allergen.sort_by(&:last).map(&:first).join(',')
  end

  private

  def build_ingredient_allergen!
    until @possibly.values.all?(&:empty?)
      ingredient, allergen = find_ingredient_with_allergen

      @ingredient_allergen[ingredient] = allergen
      @possibly.delete(ingredient)
      @possibly.transform_values { |v| v.delete(allergen) }
    end
  end

  def find_ingredient_with_allergen
    ingredient_candidate = nil
    allergen_candidate = nil
    max = 0

    @possibly.each do |ingredient, allergens|
      max_allergen_count = allergens.values.max.to_i
      next unless max_allergen_count > max && allergens.values.count(max_allergen_count) == 1

      ingredient_candidate = ingredient
      allergen_candidate = allergens.keys.find { |key| allergens[key] == max_allergen_count }
      max = max_allergen_count
    end

    [ingredient_candidate, allergen_candidate]
  end
end
