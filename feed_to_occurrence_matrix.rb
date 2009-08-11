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
	def dump_to_file file
		f = File.new(file,'w')
		@term_to_idx.to_a.sort_by{|kv| kv[1]}.each{|kv| f.puts "#{kv[1]} #{kv[0]}" }
		f.close
	end
end

raise "feed_to_occurence_matrix.rb DIR_PREFIX <MIN_TERMS_PER_DOC>" unless ARGV.length==1 or ARGV.length==2
DIR_PREFIX = ARGV.shift
MIN_TERMS_PER_DOC = (ARGV.shift.to_i if ARGV) || 30

require 'set'

doc_term_freq = []
num_non_zero_entries = 0
term_to_docs = {}
all_terms = Set.new

# get terms from stdin
doc_id = 0
id_to_url = File.new("#{DIR_PREFIX}/id_to_url",'w')
STDIN.each do |line|
	id, url, text = line.chomp.split '|'
	next unless text.split.size > MIN_TERMS_PER_DOC
	id_to_url.puts "#{doc_id} #{url.strip}"

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
		term_to_docs[term] << doc_id
	end

	doc_term_freq << term_freq
	num_non_zero_entries += term_freq.size

	doc_id += 1
end
id_to_url.close

# remove entries that correspond to a term that only appears in one document
=begin
single_entry_terms = []
term_to_docs.each do |term, docs|
	single_entry_terms << term if docs.size==1
end
single_entry_terms.each do |term|
	all_terms.delete term
	doc_term_freq.each { |tf| tf.delete term } # (though will only be one to has it removed)
	num_non_zero_entries -= 1
end
=end

# convert from terms to idxs
term_to_idx = TermToIdx.new
doc_term_freq = doc_term_freq.collect do |term_freq|
	term_freq2 = {}
	term_freq.each do |term,freq|
		idx = term_to_idx.idx_of(term)
		term_freq2[idx] = freq
	end
	term_freq2
end
term_to_idx.dump_to_file "#{DIR_PREFIX}/tom.terms"

# output sparse format
matrixf = File.new("#{DIR_PREFIX}/tom.sparse.raw",'w')
num_terms = all_terms.size
num_docs = doc_term_freq.size
matrixf.puts "#{num_terms} #{num_docs} #{num_non_zero_entries}"
doc_term_freq.each do |term_freq|
	matrixf.puts "#{term_freq.size}"
	term_freq.keys.sort.each do |term|
		matrixf.puts "#{term} #{term_freq[term]}"
	end
end
matrixf.close


