require "./lib/game_controller.rb"
require "sinatra"
require "sinatra/reloader"

configure :development do
  register Sinatra::Reloader
end

enable :sessions

game = GameController.new("dictionary.txt")

get "/" do
  erb :index, locals: { game: game }
end

post "/" do
  input = params[:guess]
  game.play_game(input)
  redirect "/"
end

get "/new" do
  game = GameController.new("dictionary.txt")
  redirect "/"
end
