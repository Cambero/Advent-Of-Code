# frozen_string_literal: true

class Day04
  attr_reader :passports

  def initialize
    @passports = open('input').read
                              .split("\n\n")
                              .map { |p| p.split(/[\s+]/) }
                              .map { |p| p.map { _1.split(':') } }
                              .map(&:to_h)
  end

  def part1
    required_fields = %w[byr iyr eyr hgt hcl ecl pid]
    passports.count { |passport| (required_fields - passport.keys).empty? }
  end

  def part2
    passports.count(&method(:valid_passport?))
  end

  private

  def valid_passport?(passport)
    [
      (1920..2002) === passport['byr'].to_i,
      (2010..2020) === passport['iyr'].to_i,
      (2020..2030) === passport['eyr'].to_i,
      validate_height(passport['hgt'].to_s),
      passport['hcl'] =~ /#[0-9a-f]{6}/,
      %w[amb blu brn gry grn hzl oth].include?(passport['ecl']),
      passport['pid'] =~ /\A\d{9}\z/
    ].all?
  end

  def validate_height(height)
    number, type = height.scan(/(\d+)(cm|in)/).first

    if type == 'cm'
      (150..193) === number.to_i
    else
      (59..76) === number.to_i
    end
  end
end
