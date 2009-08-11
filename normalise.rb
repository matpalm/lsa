#!/usr/bin/env ruby

STDIN.each do |vector|
	components = vector.split.collect {|c| c.to_f }
	magnitude = Math.sqrt components.inject(0) { |a,c| a += c*c }
	components.each do |c|
		printf "%f ", (c / magnitude)
	end
	puts
end
