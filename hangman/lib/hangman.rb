class Hangman

  def initialize(secret_word, guess, guesses)
    @word = Word.new(secret_word, guess)
    @player = Player.new(@word.secret_word.length)
    @guesses = guesses == nil ? 7 : guesses
  end

  def play
    @word.display_progress(@guesses)

    until @word.is_guessed? || @guesses == 0
      player_input = @player.input
      save if player_input == "save"
      check = @word.update_guess(player_input)
      @guesses -= 1 if check == false
      @word.display_progress(@guesses)
    end

    @word.is_guessed? ? win : lose
    File.delete("hangman.sav") if File.file?("hangman.sav")
    exit
  end

  def save
    File.open("hangman.sav", 'w') do |file|
      file.puts(@word.secret_word, @word.guess, @guesses)
    end
    puts "Saved successfully - bye!"
    exit
  end

  def win
    puts "\nWow! You win! :>"
  end

  def lose
    puts "\nAw. You lose! :<"
    puts "The word was '#{@word.secret_word}'."
  end

  class Player

    def initialize(word_length)
      @word_length = word_length
    end

    def input
      puts "\nType 'save' to save and quit, or a letter or word to guess:"

      loop do
        input = gets.chomp
        case input
          when "save" then return input
          when /^[a-zA-Z]$/, /^[a-zA-Z]{#{@word_length}}$/ then return input
        end
      end
    end


  end

  class Word

    attr_reader :secret_word, :guess

    def initialize(secret_word, guess)
      if secret_word == nil
        word_list = File.readlines("word_list.txt")
        word_list.each { |word| word.sub!(/\r\n/, "") }
        word_list.select! { |word| word.length > 4 && word.length < 13 }
        @secret_word = word_list[rand(word_list.length-1)]
      else
        @secret_word = secret_word
      end
      @guess = guess == nil ? "_" * @secret_word.length : guess
    end

    def is_guessed?
      @guess == @secret_word
    end

    def update_guess(guess)
      if guess == @secret_word
        @guess = @secret_word
      elsif !@secret_word.split("").include?(guess)
        return false
      else
        @secret_word.length.times { |i| @guess[i] = guess if @secret_word[i] == guess }
      end
      true
    end

    def display_progress(guesses)
      puts ""
      @secret_word.length.times { |i| print "#{@guess[i]} " }
      puts "\n\nYou have #{guesses} guesses left."
    end

  end

end

puts "\nWelcome to Hangman! Type (l)oad to load a saved game, (q)uit to quit, or anything else to start a new game.\n\n"

loop do
  input = gets.chomp
  case input
    when "l", "load"
      if File.file?("hangman.sav")
        savegame = File.readlines("hangman.sav").map(&:chomp)
      else
        puts "No savegame. Starting new game..."
        savegame = [nil, nil, nil]
      end
    when "q", "quit" then exit
    else savegame = [nil, nil, nil]
  end
  game = Hangman.new(*savegame)
  game.play
end
