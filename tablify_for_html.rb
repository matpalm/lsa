#!/usr/bin/env ruby

raise "tabilify_for_html.rb TABLE_DATA ROW_COLOURS IGNORE_HEADERS? COLUMN_INITIAL ROW_INITIAL" unless ARGV.length==5

file_name = ARGV.shift
colours = ARGV.shift.chars.to_a
lines = File.read(file_name).split("\n")
ignore_headers = (ARGV.shift == 'true')
column_initial = ARGV.shift
row_initial = ARGV.shift

lines.shift if ignore_headers

raise "not enough colours?" unless colours.length == lines.length

puts "<table>"

# header row
printf "<tr> <td></td> "
num_columns = lines.first.split.size
num_columns.times do |idx|
  printf "<td>#{column_initial}#{idx+1}</td> "
end
print "</tr>\n"

lines.each_with_index do |line, idx|
  printf "<tr> <td>#{row_initial}#{idx+1}</td> "
  next_colour = colours.shift
  line.split.each { |e| printf "<td class=\"#{next_colour}\">#{sprintf("%0.3f",e)}</td> " }
  printf "</tr>\n"
end

puts "</table>"
