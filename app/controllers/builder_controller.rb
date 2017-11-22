require 'matrix'

class BuilderController < ApplicationController
  def index
    @grid = Matrix[
      [1,1,1,1,1,1,1,0,1,1,1,0,1,1,1],
      [1,1,1,1,1,1,1,0,1,1,1,1,1,1,1],
      [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
      [1,1,1,1,0,1,1,1,1,0,0,1,1,1,1],
      [0,1,1,1,1,0,0,1,1,1,1,1,1,1,1],
      [0,0,1,1,1,1,1,1,0,1,1,1,0,0,0],
      [1,1,1,0,1,1,1,1,1,1,1,1,1,1,1],
      [1,1,1,1,0,1,1,1,1,0,1,1,1,1,1],
      [1,1,1,1,1,0,1,1,1,1,0,1,1,1,1],
      [1,1,1,1,1,1,1,1,1,1,1,0,1,1,1],
      [0,0,0,1,1,1,0,1,1,1,1,1,1,0,0],
      [1,1,1,1,1,1,1,1,0,0,1,1,1,1,0],
      [1,1,1,1,0,0,1,1,1,1,0,1,1,1,1],
      [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
      [1,1,1,1,1,1,1,0,1,1,1,1,1,1,1],
      [1,1,1,0,1,1,1,0,1,1,1,1,1,1,1]]

    dict_path = Rails.root.join('lib', 'assets', 'words_dictionary.json')
    dict_file = File.read(dict_path)
    
    words = JSON.parse(dict_file).keys
    @acrosses = []
    @downs = []
    across_word = []
    word_index = []

    @grid.each_with_index do |cell, row, col|
      if cell == 1
        word_index = [row, col] if across_word.empty?
        across_word.push(1)
      end
      
      if across_word.length > 0 && (cell == 0 || col == @grid.column_count-1)
        word = words.select { |word| word.length == across_word.length }.shuffle&.first || ""
        @acrosses.push([word_index, word])
        across_word = []
        word_index = []
      end
    end

    @acrosses.each do |across|
      across[1].each_char.with_index do |c, i|
        @grid.send(:[]=, across[0][0], across[0][1]+i, c)
      end
    end
  end
end
