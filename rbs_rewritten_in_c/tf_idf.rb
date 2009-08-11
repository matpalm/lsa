#!/usr/bin/env ruby

header = readline
puts header
n_terms_str, n_docs_str = header.split
n_docs = n_docs_str.to_f

STDIN.each do |line|
	row = line.split.collect {|n| n.to_f}
	sum = num_docs_with_term = 0
	row.each do |v|
		next if v==0
		sum += v
		num_docs_with_term += 1
	end
	idf = Math.log(n_docs / num_docs_with_term)
	STDERR.puts "ZERO IDF, enough of these and it might be worth removing the lines completely" if idf==0
	row = row.collect do |v| 
		tf = v / sum
		tf * idf
	end
	row.each do |v| 
		if v==0
			printf "0 "
		else
			printf "%f ", v
		end
	end
	puts
end
