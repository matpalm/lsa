#!/usr/bin/env ruby
dimension = STDIN.readline.to_i
puts "#{dimension} #{dimension}"
dimension.times do |d|
  d.times { printf "0 " }
  printf "#{STDIN.readline.chomp} "
  (dimension-d-1).times { printf "0 " }
  printf "\n"
end

