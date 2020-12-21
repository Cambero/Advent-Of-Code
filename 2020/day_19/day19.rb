# frozen_string_literal: true

class Day19
  def initialize
    rules, messages = File.open('input').read.tr('"', '').split("\n\n")

    @messages = messages.split("\n")
    @rules = rules.split("\n").map { |line| line.split(/: /) }.to_h
  end

  def part1
    run
  end

  def part2
    @rules['8'] =  "42+"
    @rules['11'] = "(?<parent>42 \\g<parent>? 31)"

    run
  end

  private

  def run
    pattern = @rules['0']

    loop do
      pattern.scan(/\d+/).each do |number|
        pattern.gsub!(/\b#{number}\b/, "(#{@rules[number.to_s]})")
      end

      break unless pattern =~ /\d+/
    end

    regexp = Regexp.new "^(#{pattern.tr(' ', '')})$"

    @messages.count { |message| message =~ regexp }
  end
end
