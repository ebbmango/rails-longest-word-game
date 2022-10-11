# frozen_string_literal: true

require 'open-uri'

# Controller for all game related actions
class GamesController < ApplicationController
  VOWELS = %w[A E I O U Y].freeze

  def new
    @letters = Array.new(5) { VOWELS.sample }
    @letters += Array.new(5) { (('A'..'Z').to_a - VOWELS).sample }
    @letters.shuffle!
  end

  def score
    # raise
    @letters = params[:letters].split
    @word = params['word'].upcase
    @contained = contained?(@word, @letters)
    @exists = exists?(@word)
  end

  private

  def contained?(word, letters)
    word.chars.all? { |char| word.count(char) <= letters.count(char) }
  end

  def exists?(word)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end
end
