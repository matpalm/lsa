#!/usr/bin/env ruby

raise "tabilify_for_html.rb TABLE_DATA ROW_COLOURS HEADERS?" unless ARGV.length==3

file_name = ARGV.shift
colours = ARGV.shift.chars.to_a
lines = File.read(file_name).split("\n")
ignore_headers = (ARGV.shift == 'true')

lines.shift if ignore_headers

raise "not enough colours?" unless colours.length == lines.length

puts "<table>"
lines.each do |line|
	out = ["<tr>"]
	next_colour = colours.shift
	line.split.each { |e| out << "<td class=\"#{next_colour}\">#{sprintf("%0.3f",e)}</td>" }
	out << "</tr>"
	puts out.join ' '
end
puts "</table>"
