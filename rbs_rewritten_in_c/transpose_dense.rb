#!/usr/bin/env ruby
require 'matrix'
n_rows, n_cols = STDIN.readline.split #header
puts "#{n_cols} #{n_rows}"

new_rows = []
n_cols.to_i.times { new_rows << [] }
STDIN.each do |line| 
	line.split.each_with_index do |e, idx|
		new_rows[idx] <<  e
	end
end
new_rows.each do |row|
	puts row.join ' '
end

