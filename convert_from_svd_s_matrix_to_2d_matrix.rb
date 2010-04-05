#!/usr/bin/env ruby
actual_dimensionality_required   = ARGV.first.to_i
dimensionality_as_specified_by_s = STDIN.readline.to_i
raise "logic error" unless actual_dimensionality_required >= dimensionality_as_specified_by_s

additional_dimensions = actual_dimensionality_required - dimensionality_as_specified_by_s

puts "#{actual_dimensionality_required} #{actual_dimensionality_required}"
dimensionality_as_specified_by_s.times do |d|
  d.times { printf "0 " }
  printf "#{STDIN.readline.chomp} "
  (dimensionality_as_specified_by_s-d-1+additional_dimensions).times { printf "0 " }
  printf "\n"
end

additional_dimensions.times do |d|
  puts "0 " * actual_dimensionality_required
end

