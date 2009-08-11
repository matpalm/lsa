#!/usr/bin/env ruby

class Array 
	def stats
		sorted = sort
		total = inject{|a,v| a+v }
		out = "min=#{sorted.first}"		
		out += " mean=#{total.to_f / size}"
		out += " median=#{sorted[size/2]}"
		out += " max=#{sorted.last}" 
		out += " size=#{size}"
		out += " total=#{total}"
	end
end

num_unreachable_sites = 0
num_reachable_sites = 0

term_freq = {}
term_freq.default = 0

num_terms_per_site = []

STDIN.each do |line|
	id,url,content = line.split '|'
	content.strip!
	if content.empty?
		num_unreachable_sites += 1 
		next
	end
	num_reachable_sites += 1

	terms = content.split
	terms.each { |t| term_freq[t] += 1 }
	num_terms_per_site << terms.size

end

puts "num_unreachable_sites #{num_unreachable_sites}"
puts "num_reachable_sites #{num_reachable_sites}"
puts "term_freq #{term_freq.values.stats}" 
puts "num_terms_per_site #{num_terms_per_site.stats}" 
