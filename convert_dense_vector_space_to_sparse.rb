#!/usr/bin/env ruby
# convert a dense vector space
# 1 0 0 -2 7 0 0 
# to a sparse one
# (0,1) (3,2) (4,7)

puts STDIN.readline # matrix sizes header 
STDIN.each do |line|
	line.split.each_with_index do |elem,idx|
		printf "%i %s ", idx, elem if elem.to_f!=0
	end
	puts
end 
