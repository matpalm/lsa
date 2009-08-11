#!/usr/bin/env ruby

# convert a sparse matrix with raw frequencies
# to a sparse tf idf matrix

first_line = STDIN.readline
num_cols, num_rows, num_entries_in_file = first_line.split.collect {|e| e.to_i}
#STDERR.puts "num_cols #{num_cols} num_rows #{num_rows} num_entries_in_file #{num_entries_in_file}"

# slurp in sparse vector
# one entry in rows per row
# each pair of entries in array is idx value pair
# [2,1, 5,1, 6,1, 7,1]
# [0,3, 1,1, 2,1, 3,1]
# [0,2, 4,1, 5,1]
rows = []
while num_entries_in_file > 0	do
	entries_in_row = STDIN.readline.to_i
	row = []
	min_key = -1 # this is only used as a guard against svd -r -w -c which, i suspect, emits rows _not_ in idx order
	entries_in_row.times do 
		key, value = STDIN.readline.split.collect {|e| e.to_i}
		raise "keys not increasing?? min_key=#{min_key} key=#{key}" if key < min_key
		row << key << value
		min_key = key
	end
	rows << row
	num_entries_in_file -= entries_in_row
end

output_rows = []
rows.size.times { output_rows << [] }

while true do

	# [2,1, 5,1, 6,1, 7,1]
	# [0,3, 1,1, 2,1, 3,1]
	# [0,2, 4,1, 5,1]
	first_elems = rows.collect{|r| r.first}.compact
	break if first_elems.empty?
	next_idx = first_elems.min

	# build data for calculating tf_idf, 
	# includes sums (for tf) and number of docs (for idf)
	# and 'processing' array is a list of row_idx, value pairs,
	# eg if processing idx 0 in above example processing will be [ [1,3], [2,2] ]
	processing = []
	idx = 0
	row_total = 0
	rows.each do |row|
		if row.first == next_idx
			row.shift # index, which we can ignore since it's next_idx
			value = row.shift
			processing << [idx,value]
			row_total += value
		end
		idx += 1
	end

	# with processing of [ [1,3], [2,2] ]
	# can calculate tf and idf, 
	idf = Math.log(rows.size.to_f / processing.size)
	processing.each do |row_idx, term_raw|
		tf = term_raw.to_f / row_total
		tf_idf = tf * idf
		output_rows[row_idx] << next_idx << tf_idf
	end

end

# reoutput matrix with tf_idf values
puts first_line
output_rows.each do |row|
	puts row.size / 2	
	while not row.empty?
		idx = row.shift
		tf_idf = row.shift
		puts "#{idx} #{tf_idf}"
	end
end

