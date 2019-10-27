require "./lib/game_controller.rb"
require "sinatra"
require "sinatra/reloader"

configure :development do
  register Sinatra::Reloader
end

enable :sessions

game = GameController.new("dictionary.txt")
i = 0

get "/" do
  i += 1 if i < 6
  erb :index, locals: { game: game, i: i }
end

post "/" do
  input = params[:guess]
  game.play_game(input)
  redirect "/"
end

get "/new" do
  game = GameController.new("dictionary.txt")
  i = 0
  redirect "/"
end

def image_setter(i)
  "hangman#{i}"
end
