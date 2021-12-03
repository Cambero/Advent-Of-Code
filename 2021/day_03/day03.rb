# frozen_string_literal: true

diagnostic_report = open('input').read.split("\n")

def mcv(report, position)
  report.count { _1[position] == '1' } >= report.count { _1[position] == '0' } ? '1' : '0'
end

def lcv(report, position)
  report.count { _1[position] == '1' } >= report.count { _1[position] == '0' } ? '0' : '1'
end

def calculate_rate(report, strategy)
  report.first.size.times.map { send(strategy, report, _1) }.join.to_i(2)
end

gamma   = calculate_rate(diagnostic_report, :mcv)
epsilon = calculate_rate(diagnostic_report, :lcv)
power_consumption = gamma * epsilon
puts power_consumption == 841_526

# Part 2
def rating_for(report, strategy, position = 0)
  return report.first.to_i(2) if report.size == 1

  keep = send(strategy, report, position)
  report = report.select { _1[position] == keep }

  rating_for(report, strategy, position + 1)
end

oxygen_generator = rating_for(diagnostic_report, :mcv)
co2_scrubber     = rating_for(diagnostic_report, :lcv)
life_support = oxygen_generator * co2_scrubber
puts life_support == 4_790_390
