#!/usr/bin/env ruby

class Array
	def magnitude
		@mag ||= calc_mag
	end
	def calc_mag
		mag = 0.to_f
		each_with_index do |e,idx|
			mag += e*e if idx%2==1 # ie every second contributes to magnitude
		end
		mag = Math.sqrt mag
	end
	def dot_product other
		self_iter = other_iter = 0
		done = false
		dp = 0
		while not done
			self_idx = self[self_iter]
			other_idx = other[other_iter]
			if self_idx == other_idx
				dp += self[self_iter+1] * other[other_iter+1]
				self_iter += 2
				other_iter += 2
				done = self_iter >= size || other_iter >= other.size
			elsif self_idx < other_idx
				self_iter += 2
				done = self_iter >= size 
			else # self_idx > other_idx
				other_iter += 2
				done = other_iter >= other.size
			end
		end
		dp
	end
	def similarity other
		dp = dot_product(other)
		mag_prod = (magnitude * other.magnitude)
		sim =  dp / mag_prod # -1 to 1
		(sim+1)/2 # 0 to 1
	end
end

vectors = []
num_rows,num_cols,entries_to_read = STDIN.readline.split.collect {|e|e.to_i} # matrix size header
while entries_to_read > 0
	num_entries_in_row = STDIN.readline.to_i
	vector = []
	num_entries_in_row.times do 
		idx,value = STDIN.readline.split
		vector << idx.to_i << value.to_f
	end
	vectors << vector
	entries_to_read -= num_entries_in_row
end
n = vectors.size

pairwise_distances = []
i = 0
#(0...n).each do |i|
	((i+1)...n).each do |j|
		pairwise_distances << [i,j,vectors[i].similarity(vectors[j])]
	end
#end
pairwise_distances = pairwise_distances.sort_by{|e| -e[2]}
pairwise_distances.each{|e| puts e.inspect}

