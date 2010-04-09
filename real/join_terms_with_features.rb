#!/usr/bin/env ruby
raise "usage: join_terms_with_feature.rb decomp-US tom.terms" unless ARGV.length==2

us_matrix = File.open(ARGV.shift, 'r')
tom_terms = File.open(ARGV.shift, 'r')

us_matrix.readline # ignore header

while !us_matrix.eof? do
  raise "tom.terms ran out before us_matrix" if tom_terms.eof?

  term_id, term = tom_terms.readline.chomp.split
  printf "#{term} "

  us_matrix_entries = us_matrix.readline.chomp.split
  us_matrix_entries.each { |entry| printf "%0.10f ",entry.to_f }

  printf "\n"

end
raise "us_matrix ran out before tom.terms" unless tom_terms.eof?

