class View
  attr_accessor :original_word, :display_word, :incorrect_guesses, :incorrect_no

  def initialize(original_word)
    @original_word = original_word
    @display_word = hide_word(original_word)
    @incorrect_guesses = []
    @incorrect_no = 0
  end

  def display
    puts "+++++++++++++++++++++++++"
    puts "Guess the word....?"
    puts "        "
    puts display_word.split("").join(" ")
    puts "        "
    puts "Incorrect Guesses: #{incorrect_guesses.join(", ")}" if incorrect_no > 0
  end

  def check_guess(input)
    input = input.downcase
    if input.length > 1
      if input == original_word
        @display_word = original_word
      else
        incorrect_guesses << input
        @incorrect_no += 1
      end
    else
      if original_word.include?(input)
        original_word.split("").each_with_index do |letter, i|
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

  private

  def hide_word(word)
    "-" * word.length
  end
end
