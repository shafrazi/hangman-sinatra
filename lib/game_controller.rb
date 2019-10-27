class GameController
  attr_reader :word
  attr_accessor :display_word, :no_of_guesses, :game_over, :incorrect_guesses, :incorrect_no

  def initialize(dictionary_file)
    @word = generate_word(dictionary_file)
    @display_word = hide_word(@word)
    @game_over = false
    @no_of_guesses = 5
    @incorrect_guesses = []
    @incorrect_no = 0
  end

  def generate_word(dictionary_file)
    words_array = File.readlines(dictionary_file)
    word = ""
    while check_length(word)
      word = words_array[random_num(words_array)].chomp.downcase
    end
    return word
  end

  def display
    if @game_over == false
      display_word.split("").join("   ")
    elsif @game_won
      "Congratulations! You successfully guessed the word!"
    elsif @no_of_guesses == 0
      "Game over! The word is : #{word.split("").join("  ")}"
    end
  end

  def random_num(array)
    rand(array.length)
  end

  def check_length(word)
    if word.length >= 5 && word.length < 8
      false
    else
      true
    end
  end

  def hide_word(word)
    "_" * word.length
  end

  def check_guess(input)
    input = input.downcase
    if input.length > 1
      if input == word
        @display_word = word
      else
        incorrect_guesses << input
        @incorrect_no += 1
      end
    else
      if word.include?(input)
        word.split("").each_with_index do |letter, i|
          if letter == input
            @display_word[i] = input
          end
        end
      else
        incorrect_guesses << input
        @incorrect_no += 1
      end
    end
  end

  def play_game(input)
    if @no_of_guesses > 0
      check_guess(input)
      @no_of_guesses -= 1
      if input == word || display_word == word
        @game_won = true
        @game_over = true
      end
    else
      @game_lost = true
      @game_over = true
    end
  end
end
