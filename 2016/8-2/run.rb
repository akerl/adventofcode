#!/usr/bin/env ruby

require 'matrix'

class Screen
  def initialize
    @grid = Matrix.zero(6, 50).to_a
  end

  def commands
    @commands ||= {
      /^rect (?<cols>\d+)x(?<rows>\d+)/ => proc { |x| draw_rect(x[:rows].to_i, x[:cols].to_i) },
      /^rotate row y=(?<row>\d+) by (?<count>\d+)/ => proc { |x| rotate_row(x[:row].to_i, x[:count].to_i) },
      /^rotate column x=(?<col>\d+) by (?<count>\d+)/ => proc { |x| rotate_col(x[:col].to_i, x[:count].to_i) }
    }
  end

  def draw_rect(rows, cols)
    0.upto(cols - 1) do |col|
      0.upto(rows - 1) do |row|
        @grid[row][col] = 1
      end
    end
  end

  def rotate_row(row, count)
    @grid[row].rotate! count * -1
  end

  def rotate_col(col, count)
    flipped = @grid.transpose
    flipped[col].rotate! count * -1
    @grid = flipped.transpose
  end

  def run_cmd(cmd)
    commands.each do |cmd_regex, func|
      match = cmd.match(cmd_regex)
      if match
        puts cmd
        func.call(match)
        p @grid
        return
      end
    end
    fail "Unknown command: #{cmd}"
  end

  def count
    @grid.flatten.select { |x| x == 1 }.size
  end

  def display
    @grid.each do |row|
      puts row.map(&:to_s).join.tr('0',' ')
    end
  end
end

screen = Screen.new
File.readlines('input').each { |x| screen.run_cmd(x) }
screen.display

