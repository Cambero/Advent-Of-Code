# frozen_string_literal: true

class Day22
  PLAYER1 = :player1
  PLAYER2 = :player2

  def initialize
    @player1, @player2 = File.open('input')
                             .read
                             .split("\n\n")
                             .map { |player| player.scan(/^\d+$/).map(&:to_i) }
  end

  def part1
    play_round!(@player1, @player2) until end_game?

    score
  end

  def part2
    recursive_game? ? play_recursive_game : play_round!(@player1, @player2) until end_game?

    score
  end

  private

  def end_game?
    @player1.empty? || @player2.empty?
  end

  def play_round!(deck1, deck2)
    card1 = deck1.shift
    card2 = deck2.shift

    if card1 > card2
      deck1 << card1 << card2
    else
      deck2 << card2 << card1
    end
  end

  def score
    (@player1 + @player2).reverse
                         .map
                         .with_index { |card, i| card * (i + 1) }
                         .sum
  end

  def recursive_game?
    @player1.size > @player1.first && @player2.size > @player2.first
  end

  def play_recursive_game
    card1 = @player1.shift
    card2 = @player2.shift

    if winner_sub_game(@player1[0, card1].dup, @player2[0, card2].dup) == PLAYER1
      @player1 << card1 << card2
    else
      @player2 << card2 << card1
    end
  end

  def winner_sub_game(deck1, deck2)
    stack = [[deck1.dup, deck2.dup]]

    until deck1.empty? || deck2.empty?
      play_round!(deck1, deck2)

      return PLAYER1 if stack.include?([deck1, deck2])

      stack << [deck1.dup, deck2.dup]
    end

    deck1.empty? ? PLAYER2 : PLAYER1
  end
end
