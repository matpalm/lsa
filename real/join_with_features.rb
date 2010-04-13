#!/usr/bin/env ruby
# join either terms or urls with features
raise "usage: join_with_feature.rb <terms|urls>" unless ARGV.length==1

type = ARGV.first
raise "expecting 'terms' or 'urls' as arg" unless type=='terms' || type=='urls'

input_matrix_file = type=='terms' ? 'decomp-US' : 'decomp-VS'
identifier_file   = type=='terms' ? 'tom.terms' : 'id_to_url'

matrix      = File.open(input_matrix_file, 'r')
identifiers = File.open(identifier_file, 'r')

matrix.readline # ignore header

while !matrix.eof? do
  raise "#{identifier_file} ran out before matrix" if identifiers.eof?

  identifier_id, identifier_text = identifiers.readline.chomp.split
  printf "#{identifier_id} #{identifier_text} "

  matrix_entries = matrix.readline.chomp.split
  matrix_entries.each { |entry| printf "%0.10f ",entry.to_f }

  printf "\n"

end
raise "#{input_matrix_file} ran out before id_to_url" unless identifiers.eof?

