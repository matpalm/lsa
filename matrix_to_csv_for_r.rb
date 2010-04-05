#!/usr/bin/env ruby
header = STDIN.readline
nr,nc = header.split
puts (0...nc.to_i).to_a.collect {|n| "f#{n+1}"}.join ','
STDIN.each { |line| puts line.split(' ').join(',') }
