#!/usr/bin/env ruby

raise "number_of_features_given_input_matrix.rb SVD_EG" unless ARGV.length==1

file = File.open(ARGV.first, 'r')
nr,nc = file.readline.split(' ')
puts nc
file.close
