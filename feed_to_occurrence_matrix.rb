#!/usr/bin/env ruby

# convert from rss feed 
# url|data|text
# to a term occurence matrix (rows being terms, cols being documents)

# use sparse matrix format as specified at http://tedlab.mit.edu/~dr/svdlibc/SVD_F_ST.html

class TermToIdx 
	def initialize
		@term_to_idx = {}
		@seq = 0
	end
	def idx_of term
		idx = @term_to_idx[term]
		return idx unless idx.nil?
		idx = @seq
		@term_to_idx[term] = idx
		@seq += 1
		idx
	end
	def dump
		puts @term_to_idx.inspect
	end
end

require 'set'

term_to_idx = TermToIdx.new
doc_term_freq = []
all_terms = Set.new
num_entries = 0

STDIN.each do |line|
	url, date, text = line.split '|'

	# get terms from line
	terms = text.gsub(/[^a-zA-Z0-9 ]/,' ').
			split(/\s+/).
			select { |w| w.length >1 }.
			collect { |w| w.downcase.to_sym }	

	all_terms += terms

	term_freq = {}
	term_freq.default = 0
	terms.each { |term| term_freq[term_to_idx.idx_of(term)] += 1 }
	doc_term_freq << term_freq
	num_entries += term_freq.size

end

num_terms = all_terms.size
num_docs = doc_term_freq.size
puts "#{num_terms} #{num_docs} #{num_entries}"

doc_term_freq.each do |term_freq|
	puts "#{term_freq.size}"
	term_freq.each do |term,freq|
		puts "#{term} #{freq}"
	end
end

