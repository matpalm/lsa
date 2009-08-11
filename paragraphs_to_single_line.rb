#!/usr/bin/env ruby
collecting = ''
STDIN.each do |line|
	line.chomp!
	if line.empty?
		if collecting.length > 80
			puts collecting.downcase.gsub(/[^A-Za-z]/,' ').gsub(/\s+/, ' ').strip
			collecting = ''
		end
	else
		collecting += line + ' '
	end
end
