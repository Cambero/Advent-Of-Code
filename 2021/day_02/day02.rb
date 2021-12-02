# frozen_string_literal: true

class Submarine
  def self.result_after(commands)
    submarine = new
    commands.each { |command| submarine.execute(command) }
    submarine.result_horizontal_by_depth
  end

  def initialize
    @horizontal = 0
    @depth = 0
  end

  def execute(command)
    movement, amount = command.split(' ')

    send(movement, amount.to_i)
  end

  def result_horizontal_by_depth
    @horizontal * @depth
  end

  private

  def forward(amount)
    @horizontal += amount
  end

  def up(amount)
    @depth -= amount
  end

  def down(amount)
    @depth += amount
  end
end

class SubmarineWithAim < Submarine
  def initialize
    super
    @aim = 0
  end

  private

  def forward(amount)
    @horizontal += amount
    @depth += @aim * amount
  end

  def up(amount)
    @aim -= amount
  end

  def down(amount)
    @aim += amount
  end
end

commands = File.open('input').readlines
puts Submarine.result_after(commands) == 1_727_835
# 1727835

puts SubmarineWithAim.result_after(commands) == 1_544_000_595
# 1544000595

