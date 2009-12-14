#!/usr/bin/env ruby
raise "./multiply.rb a_dense_matrix_file another_dense_matrix_file" unless ARGV.length==2

# read a in row order
lines = File.readlines ARGV[0]
a_header = lines.shift.split
raise "header wrong in #{ARGV[0]}, expected 2 elements, got #{a_header.size} elements" unless 2 == a_header.size
anr,anc = a_header.collect {|n| n.to_i}
raise "num rows wrong in first matrix, #{ARGV[0]}, anr(#{anr}) != #lines(#{lines.size})" unless anr == lines.size
a_rows = lines.collect { |line| line.split.collect { |n| n.to_f } }
#puts a_rows.inspect

# read b in col order
lines = File.readlines ARGV[1]
b_header = lines.shift.split
raise "header wrong in #{ARGV[1]}, expected 2 elements, got #{b_header.size} elements" unless 2 == b_header.size
bnr,bnc = b_header.collect {|n| n.to_i}
raise "anc(#{anc}) != bnr(#{bnr}), can't multiply" unless anc == bnr
b_cols = []
bnc.times { b_cols << [] }
lines.each do |line|
	line.split.each_with_index do |e, idx| 
		b_cols[idx] << e.to_f
	end
end
#puts b_cols.inspect

# multiply
result = []
anr.times { result << [] }
a_rows.each_with_index do |a_row, a_idx|
	b_cols.each_with_index do |b_col, b_idx|
		result[a_idx][b_idx] = a_row.zip(b_col).inject(0){|acc,ab| a,b=ab; acc+a*b}
	end
end
r_rows = result.size
r_cols = result.first.size
puts "#{r_rows} #{r_cols}"
result.each { |result_row| puts result_row.join(' ') }
