#!/usr/bin/env ruby
#sort by angle

class Array
	def magnitude
		Math.sqrt(self.inject(0) {|a,v| a += v*v })
	end
	def dot_product other
		dp = 0
		(0...size).each { |idx| dp += self[idx] * other[idx] }
		dp
	end
	def similarity other
		sim = dot_product(other) / (magnitude * other.magnitude) # -1 to 1
		(sim+1)/2 # 0 to 1
	end
end

vectors = STDIN.collect do |line|
	line.split.collect{|e| e.to_f}	
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

