require "net/http"
require "json"

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ("A".."Z").to_a.sample }
  end

  def score
    @word = params[:word].to_s.strip.upcase
    @letters = params[:letters].to_s.split

    if !in_grid?(@word, @letters)
      @message = "❌ Sorry, but #{@word} can't be built out of #{@letters.join(', ')}."
    elsif !english_word?(@word)
      @message = "❌ Sorry, but #{@word} does not seem to be a valid English word."
    else
      @message = "✅ Congratulations! #{@word} is a valid English word!"
    end
  end

  private

  def in_grid?(word, letters)
    word.chars.all? do |letter|
      word.count(letter) <= letters.count(letter)
    end
  end

  def english_word?(word)
    return false if word.empty?

    url = "https://dictionary.lewagon.com/#{word.downcase}"
    uri = URI.parse(url)
    response = Net::HTTP.get(uri)
    json = JSON.parse(response)
    json["found"]
  rescue
    false
  end
end
