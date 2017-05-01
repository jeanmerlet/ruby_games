class Counter

  attr_reader :correct_guesses

  def initialize
    numbers = ('1'..'13')
    suites = ['S', 'H', 'D', 'C']
    deck = []
    suites.each do |x|
      deck << numbers.map {|n| n + x }
    end
    @deck = deck.flatten
    @drawn = []
    @correct_guesses = 0
  end

  def play
    @deck.shuffle!
    until @deck.size == 1
      current_card = next_card_in_deck
      @drawn << current_card

      @deck -= [@drawn.last]
      guess = higher_or_lower(current_card)

      card = next_card_in_deck[0].to_i
      if guess == 'above' && card < current_card[0].to_i 
      elsif guess == 'below' && card > current_card[0].to_i
      else
        @correct_guesses += 1
      end
    end
  end

  def next_card_in_deck
    @deck.first
  end

  def random_card_from_deck
    @deck[rand(@deck.length)]
  end

  def higher_or_lower(card)
    above, below = 0, 0
    @deck.each {|c| above += 1 if c[0].to_i > card[0].to_i }
    @deck.each {|c| below += 1 if c[0].to_i < card[0].to_i }
    return ['above', 'below'][rand(2)] if above == below
    above > below ? 'above' : 'below'
  end

end

correct_guesses = []
10000.times do
  game = Counter.new
  game.play
  correct_guesses << game.correct_guesses
end
average = (correct_guesses.inject(0.0) { |sum, n| sum + n }) / correct_guesses.size
puts average

