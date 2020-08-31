require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = ('a'..'z').to_a.sample(10)
  end

  def score
    session[:score] = session[:score] || 0
    @letters = params[:letters].delete(' ').chars
    @word = params[:word].chars
    @comparison = @letters & @word

    @result = if valid_english_word?(params[:word]) && @word.length <= 10
                if @word.count == @comparison.count
                  session[:score] += @word.length
                  "Congratulations! #{params[:word].capitalize} is a valid English..."
                else
                  "Sorry but #{params[:word].capitalize} can't be build out of #{@letters.join(',')}"
                end
              else
                "Sorry but #{params[:word].capitalize} does not seem to be a valid English word..."
              end
    @score = session[:score]
  end

  private

  def valid_english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}").read
    json = JSON.parse(response)
    json['found']
  end
end
