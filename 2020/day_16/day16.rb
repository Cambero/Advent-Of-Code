# frozen_string_literal: true

class Day16
  def initialize
    @rules = read_rules
    @tickets = read_tickets
  end

  def part1
    @tickets
      .flat_map { |ticket| invalid_values_on(ticket) }
      .sum
  end

  def part2
    keep_only_valid_tickets!

    solution_fields
      .filter_map { |field, index| @tickets[0][index] if field.start_with?('departure') }
      .inject(:*)
  end

  private

  def read_rules
    read_input
      .scan(/(.*): (\d+)-(\d+) or (\d+)-(\d+)/)
      .map { |(name, r1s, r1e, r2s, r2e)| [name, [(r1s.to_i..r1e.to_i), (r2s.to_i..r2e.to_i)]] }
      .to_h
  end

  def read_tickets
    read_input
      .split("\n")
      .map { |ticket| ticket.split(',').map(&:to_i) }
      .reject { |numbers| numbers.size <= 1 }
  end

  def read_input
    File.open('input').read || ''
  end

  def invalid_values_on(ticket)
    ticket.select do |value|
      @rules.values.none? do |range1, range2|
        range1.cover?(value) || range2.cover?(value)
      end
    end
  end

  def keep_only_valid_tickets!
    @tickets.select! { |ticket| invalid_values_on(ticket).empty? }
  end

  def solution_fields
    possible_fields = valid_fields

    solution_fields = {}

    while unique = possible_fields.find { |arr| arr.size == 1 }&.first
      solution_fields[unique] = possible_fields.index([unique])

      possible_fields.each { |f| f.delete(unique) }
    end

    solution_fields
  end

  def valid_fields
    @rules.size.times.each_with_object([]) do |position, fields|
      numbers = @tickets.map { |ticket| ticket[position] }

      fields[position] = @rules.filter_map do |name, ranges|
        name if numbers.all? { |number| ranges.any? { |range| range.cover?(number) } }
      end
    end
  end
end
