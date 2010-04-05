#!/usr/bin/env ruby

# convert from rss feed 
# url|date|text
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
MIN_TERMS_PER_DOC = (ARGV.shift.to_i if ARGV) || 30 # ignore docs smaller than this

# if 0.15 then 
# remove terms that appear is less than 0.15 of docs and 
# remove terms that appear in more than 0.85 of docs
TERM_FREQ_CUTOFF = 0.10

require 'set'

global_term_freq = {}
global_term_freq.default = 0
doc_term_freq = []
num_non_zero_entries = 0
term_to_docs = {}
all_terms = Set.new

# get terms from stdin
doc_id = 0
id_to_url = File.new("#{DIR_PREFIX}/id_to_url",'w')
STDIN.each do |line|
  url, date, text = line.chomp.split '|'
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
    global_term_freq[term] += 1
    term_freq[term] += 1 
    term_to_docs[term] ||= Set.new
    term_to_docs[term] << doc_id
  end
  
  doc_term_freq << term_freq
  num_non_zero_entries += term_freq.size
  
  doc_id += 1
end
id_to_url.close

#puts "$$$$$$$$$$$$$$$$ before any purge"
#puts term_to_docs.to_a.collect {|ts| [ts[0],ts[1].size] }.sort {|a,b| a[1]<=>b[1]}.inspect
#puts term_to_docs.size

terms_to_remove = []
remove_freq_lowerbound = doc_id * TERM_FREQ_CUTOFF
remove_freq_upperbound = doc_id * (1.0 - TERM_FREQ_CUTOFF)
term_to_docs.each do |term, docs|
  terms_to_remove << term if docs.size <= remove_freq_lowerbound || docs.size >= remove_freq_upperbound
end
terms_to_remove.each do |term|
  all_terms.delete term
  doc_term_freq.each { |tf| tf.delete term } 
  term_to_docs.delete term
  num_non_zero_entries -= 1
end

#puts "$$$$$$$$$$$$$$$$ AFTER purge"
#puts term_to_docs.to_a.collect {|ts| [ts[0],ts[1].size] }.sort {|a,b| a[1]<=>b[1]}.inspect
#puts term_to_docs.size

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


