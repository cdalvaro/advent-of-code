# frozen_string_literal: true

module AdventOfCode
  module Puzzles2023
    module Day03
      ##
      # Class for solving Day 3 - Part 1 puzzle
      class Part1
        ##
        # An array of hashes with the indexes and numbers of the
        # numbers in each line.
        # @return [Array<Hash<Integer, String>>] matrix of number indexes and numbers
        attr_reader :numbers

        ##
        # An array of hashes with the indexes of the symbols and
        # the current symbol in each line.
        # @return [Array<Hash<Integer, String>>] matrix of symbol indexes and symbols
        attr_reader :symbols

        ##
        # @param file [String] path to input file
        def initialize(file: nil)
          file ||= "#{File.dirname(__FILE__)}/input.txt"
          file_contents = File.readlines(file, chomp: true)
          @symbols = extract_symbols(file_contents)
          @numbers = extract_numbers(file_contents)
        end

        ##
        # Get the sum of the engine part numbers.
        #
        # @return [Integer] sum of the engine part numbers
        def answer
          part_numbers.sum
        end

        ##
        # Method to extract engine parts from file contents.
        #
        # @return [Array<Integer>] array of engine part numbers
        def part_numbers
          return @part_numbers if @part_numbers

          @part_numbers = []
          numbers.each_with_index do |row_numbers, row_idx|
            row_numbers.each do |number_idx, number|
              # This array contains all the valid indexes of the symbols
              # that are next to the number.
              # This array is theoretical, because it contains indexes
              # that are not in the symbols matrix.
              valid_indexes = number_idx - 1..number_idx + number.length

              # Select all indexes from the symbols matrix that are in an
              # adjacent row. If one of those indexes is in the
              # valid_sym_idx array, then the number is next to a symbol.
              if adjacent_rows_symbols(symbols, row_idx).any? { |idx| valid_indexes.include?(idx) }
                @part_numbers << number.to_i
                next
              end
            end
          end

          @part_numbers
        end

        protected

        ##
        # Method to get indexes of symbols in file contents.
        # The indexes are returned as a matrix, where each row
        # represents a line in the file with the indexes of the
        # symbols in that line.
        #
        # @param file_contents [Array<String>] array of file lines
        #
        # @return [Array<Hash<Integer, String>>] matrix of symbol indexes and symbols
        def extract_symbols(file_contents)
          # Get all matches for non-numeric characters and dot character
          file_contents.map { |line| find_elements_in_line(line, %r{[^.0-9]}) }
        end

        ##
        # Method to get the indexes of the numbers in file contents
        # and their corresponding number.
        # The indexes are returned as a matrix, where each row
        # contains a hash of the index of the number and its number.
        #
        # @param file_contents [Array<String>] array of file lines
        #
        # @return [Array<Hash<Integer, String>>] matrix of number indexes and numbers
        def extract_numbers(file_contents)
          # Get all numbers and their indexes
          file_contents.map { |line| find_elements_in_line(line, %r{[0-9]+}) }
        end

        ##
        # Given a line and a regex, find all the matches in the line
        # and return a hash with the index of the match and the match.
        #
        # @param line [String] line to search
        # @param regex [Regexp] regex to search for
        #
        # @return [Hash<Integer, String>] hash with the index of the match and the match
        def find_elements_in_line(line, regex)
          line.enum_for(:scan, regex).to_h do |element|
            index = Regexp.last_match&.begin(0)
            [index, element]
          end
        end

        ##
        # Get the range of the adjacent rows to the given row index.
        #
        # @param row_index [Integer] index of the row to check
        # @param max_index [Integer] maximum index of the matrix
        #
        # @return [Range<Integer>] array of indexes
        def adjacent_rows_range(row_index, max_index)
          min_row = row_index.positive? ? row_index - 1 : row_index
          max_row = row_index < max_index ? row_index + 1 : row_index
          min_row..max_row
        end

        ##
        # Select unique indexes from the symbols matrix that are
        # in an adjacent row to the given row index.
        #
        # @param symbols [Array<Array<Integer>>] matrix of symbol indexes
        # @param row_index [Integer] index of the row to check
        #
        # @return [Array<Integer>] array of unique indexes
        def adjacent_rows_symbols(symbols, row_index)
          # Adjacent rows
          adjacent_symbol_rows = adjacent_rows_range(row_index, symbols.length - 1)

          # Select all different indexes from the adjacent rows
          # Duplicated indexes can be removed
          symbols.values_at(*adjacent_symbol_rows).map(&:keys).flatten.uniq
        end
      end
    end
  end
end
