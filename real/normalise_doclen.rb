#!/usr/bin/env ruby

# simple normalisation of a sparse term occurence matrix
# by dividing each term count by the total num terms in each document

header = STDIN.readline
puts header

loop do  
  exit if STDIN.eof?
  num_entries_in_this_row = STDIN.readline.to_i
  puts num_entries_in_this_row

  entries = []
  total = 0.0
  num_entries_in_this_row.times do
    entry = STDIN.readline.split
    term_id, count = entry.first, entry.last.to_f
    entries << [ term_id, count ]
    total += count
  end

  entries.each do |entry|
    puts "#{entry.first} #{entry.last / total}"
  end

end

