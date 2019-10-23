require_relative "word.rb"
require_relative "view.rb"
require "json"

class Game
  attr_accessor :word, :view, :no_of_guesses, :user_input, :game_over, :user_input

  def initialize(dictionary_file)
    @word = Word.new(dictionary_file).word_gen
    @view = View.new(@word)
    @game_over = false
    @no_of_guesses = 6
    @user_input = ""
  end

  def new_game
    puts "Welcome to Hangman!"
    puts "Choose an option:"
    puts "   1. Start new game"
    puts "   2. Load a saved game"
    input = gets.chomp.to_i
    if input == 1
      start_game
    elsif input == 2
      load_game
    else
      puts "Invalid input"
    end
  end

  def start_game
    while !game_over
      puts "No of available guesses: #{@no_of_guesses}"
      view.display
      puts "Enter your guess or if you wish to save the game enter 'save game':"
      @user_input = gets.chomp
      if @user_input == "save game"
        self.save_game
        break
      else
        view.check_guess(@user_input)
        @no_of_guesses -= 1
      end
    end
  end

  def game_over
    if user_input == word || no_of_guesses == 0 || view.display_word == word
      if user_input == word
        puts "Congratulations! Your last guess was correct!"
        puts view.display_word.split("").join(" ")
      elsif view.display_word == word
        puts "Congratulations! You successfully guessed the word!"
        puts view.display_word.split("").join(" ")
      elsif no_of_guesses == 0
        puts "You lose! You ran out of available guesses!"
        puts "Correct word is: #{word.split("").join(" ")}"
      end
      @game_over = true
    end
  end

  def as_json
    { word: @word, view: { original_word: view.original_word, display_word: view.display_word, incorrect_guesses: view.incorrect_guesses, incorrect_no: view.incorrect_no }, game_over: @game_over, no_of_guesses: @no_of_guesses, user_input: @user_input }
  end

  def self.from_json(file, dictionary_file)
    json = File.read(file)
    data = JSON.parse(json)
    loaded_game = new(dictionary_file)
    loaded_game.word = data["word"]
    loaded_game.view.original_word = data["view"]["original_word"]
    loaded_game.view.display_word = data["view"]["display_word"]
    loaded_game.view.incorrect_guesses = data["view"]["incorrect_guesses"]
    loaded_game.view.incorrect_no = data["view"]["incorrect_no"]
    # loaded_game.game_over = data["game_over"]
    loaded_game.no_of_guesses = data["no_of_guesses"]
    # loaded_game.user_input = data["user_input"]
    return loaded_game
  end

  def load_game
    directory = "saved_games"
    dictionary_file = "dictionary.txt"
    files_hash = {}
    files_array = Dir.children(directory)

    files_array.each_with_index do |file, i|
      if !files_hash[i + 1]
        files_hash[i + 1] = file
      end
    end
    puts "Select a save file to load:"
    files_hash.each do |key, value|
      puts "  #{key}. #{value.split(".")[0]}"
    end

    selection = gets.chomp.to_i
    loaded_game = Game.from_json("saved_games/#{files_hash[selection]}", dictionary_file)
    loaded_game.start_game
  end

  def save_game
    puts "Enter file name to save the game:"
    file_name = gets.chomp
    data = self.as_json
    File.write("saved_games/#{file_name}#{".json"}", JSON.dump(data))
  end
end