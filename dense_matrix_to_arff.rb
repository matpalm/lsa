#!/usr/bin/env ruby

num_cols = STDIN.readline.chomp.split[1].to_i
raise "expect >=1 cols" unless num_cols >= 1

puts "@RELATION X"
num_cols.times { |i| puts "@ATTRIBUTE f#{i} numeric" }
puts "@DATA"

STDIN.each do |row|
  cols = row.split
  raise "row starting with #{row[0,10]} had #{cols.size} cols, expected #{num_cols}" unless cols.size == num_cols
  puts cols.join(', ')  
end
