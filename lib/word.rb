class Word
  attr_accessor :word_gen

  def initialize(dictionary_file)
    @word_gen = generate_word(dictionary_file)
  end

  private

  def generate_word(dictionary_file)
    words_array = File.readlines(dictionary_file)
    word = ""
    while check_length(word)
      word = words_array[random_num(words_array)].chomp.downcase
    end
    return word
  end

  def random_num(array)
    rand(array.length)
  end

  def check_length(word)
    if word.length >= 5 && word.length < 12
      false
    else
      true
    end
  end
end
