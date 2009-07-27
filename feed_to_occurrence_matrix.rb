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

doc_term_freq = []
num_non_zero_entries = 0
term_to_docs = {}
all_terms = Set.new

# get terms from stdin
STDIN.each_with_index do |line, doc|
	url, date, text = line.split '|'

	terms = text.gsub(/[^a-zA-Z0-9 ]/,' ').
			split(/\s+/).
			select { |w| w.length >1 }.
			collect { |w| w.downcase.to_sym }	

	all_terms += terms

	term_freq = {}
	term_freq.default = 0
	terms.each do |term| 
		term_freq[term] += 1 
		term_to_docs[term] ||= Set.new
		term_to_docs[term] << doc
	end

	doc_term_freq << term_freq
	num_non_zero_entries += term_freq.size

end

# remove entries that correspond to a term that only appears in one document
single_entry_terms = []
term_to_docs.each do |term, docs|
	single_entry_terms << term if docs.size==1
end
single_entry_terms.each do |term|
	all_terms.delete term
	doc_term_freq.each { |tf| tf.delete term } # (though will only be one to has it removed)
	num_non_zero_entries -= 1
end

# convert from terms to idxs
term_to_idx = TermToIdx.new
doc_term_freq = doc_term_freq.collect do |term_freq|
	term_freq2 = {}
	term_freq.each do |term,freq|
		term_freq2[term_to_idx.idx_of(term)] = freq
	end
	term_freq2
end

# output sparse format
num_terms = all_terms.size
num_docs = doc_term_freq.size
puts "#{num_terms} #{num_docs} #{num_non_zero_entries}"
doc_term_freq.each do |term_freq|
	puts "#{term_freq.size}"
	term_freq.each do |term,freq|
		puts "#{term} #{freq}"
	end
end

