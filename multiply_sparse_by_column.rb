#!/usr/bin/env ruby
# made for mulitplying U by S (where S is just single column representing diagonal)
raise "./multiply_US.rb sparse_matrix_file column_vector_file" unless ARGV.length==2

lines = File.readlines ARGV[0]
anr,anc = lines.shift.split.collect {|n| n.to_i}
raise "num rows wrong in first matrix, #{ARGV[0]}" unless anr == lines.size
a_rows = lines.collect { |line| line.split.collect { |n| n.to_f } }
#puts "a_rows = #{a_rows.inspect}"

lines = File.readlines ARGV[1]
bnrc = lines.shift.to_i
STDERR.puts "WARNING: anc(#{anc}) > bnrc(#{bnrc}), assuming b filled with zeros" unless anc == bnrc
b_diagonals = lines.collect { |n| n.to_f }
while b_diagonals.size < a_rows.size 
	b_diagonals << 0
end
#puts "b_diagonals = #{b_diagonals.inspect}"

result = a_rows.collect do |a_row|
	a_row.zip(b_diagonals).collect do |ab| 
		a,b = ab
		a*b
	end
end

puts (1..a_rows.first.size).collect { |n| "V#{n}" }.join(',')
result.each { |row| puts row.join ',' }

