#!/usr/bin/env ruby
#web_contents_to_sample

N = ARGV.first.to_i
collected = 0
STDIN.each do |line|
	next unless line =~ /\|/
	line.sub! /.*\|/, ''
	next if line.split.size < 100
	puts "#{collected}|#{line}"
	collected += 1
	exit 0 if collected == N
end
