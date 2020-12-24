# frozen_string_literal: true

class Day23
  def initialize
    @game = Game.new
    File.open('input').read.chomp.chars.map(&:to_i).each do |cup|
      @game.append(cup)
    end
  end

  def part1
    100.times { @game.move }

    node = @game.node_one
    8.times.map { (node = node.next).value }.join
  end

  def part2
    (10..1_000_000).each { |cup| @game.append(cup) }
    10_000_000.times { @game.move }

    node = @game.node_one
    node.next.value * node.next.next.value
  end
end

class Cup
  attr_accessor :next
  attr_reader :value

  def initialize(value)
    @value = value
    @next  = nil
  end
end

class Game
  def initialize
    @index = {}
    @tail = nil
    @current = nil
  end

  def append(value)
    cup = Cup.new(value)
    @index[value] = cup
    if @tail
      cup.next = @tail.next
      @tail.next = cup
    else
      cup.next = cup
      @current = cup
    end
    @tail = cup
  end

  def node_one
    @index[1]
  end

  def move
    pick_up = @current.next
    @current.next = pick_up.next.next.next

    destination = find_destination(pick_up)

    pick_up.next.next.next = @index[destination].next
    @index[destination].next = pick_up

    @current = @current.next
  end

  private

  def find_destination(pick_up)
    pick_up_values = [pick_up.value, pick_up.next.value, pick_up.next.next.value]
    destination = @current.value

    loop do
      destination = destination == 1 ? @index.size : destination - 1
      break unless pick_up_values.include?(destination)
    end

    destination
  end
end
