require "json"
require "open-uri"

class GamesController < ApplicationController
  def new
    @letters = []
    array = ('A'..'Z').to_a
    10.times { @letters << array.sample }
  end

  def score
    # Le mot ne peut pas être créé à partir de la grille d’origine.
    # Le mot est valide d’après la grille, mais ce n’est pas un mot anglais valide.
    # Le mot est valide d’après la grille et est un mot anglais valide.
    url = "https://wagon-dictionary.herokuapp.com/#{params[:answer]}"
    words_serialized = URI.open(url).read
    words = JSON.parse(words_serialized)

    @letters = params[:random_letters].split(" ")
    @item = params[:answer].upcase
    @correct = @item.chars.all? do |letter|
      @item.count(letter) <= @letters.count(letter)
    end
  if @correct == true && words["found"] == true
    @answer = "Congratulations! #{params[:answer].upcase} is a valid English word"
  elsif @correct == true && words["found"] == false
    @answer = "Sorry but #{params[:answer].upcase} does not seem to be a valid English word..."
  else
    @answer = "Sorry but #{params[:answer].upcase} can't be built out of #{@letters}."
  end
  end
end
