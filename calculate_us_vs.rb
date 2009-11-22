#!/usr/bin/env ruby

class Decomposer

	def initialize	a, num_dimensions
		@a = a
		@num_dimensions = num_dimensions 
		@prefix = "_#{a}_#{num_dimensions}d"
	end

	def run cmd
		puts cmd
		`#{cmd}`
	end

	def perform_svd
		run "./svd -d #{@num_dimensions} -r dt -v 0 -o #{@prefix} #{@a}"
	end

	def transpose u_or_v
		run "./transpose < #{@prefix}-#{u_or_v}t > #{@prefix}-#{u_or_v}"
	end

	def multiple u_or_v
		run "./multiply_sparse_by_column.rb #{@prefix}-#{u_or_v} #{@prefix}-S > #{@prefix}-#{u_or_v}S.csv"
	end
	
	def decompose
		fork do
		  perform_svd
			transpose 'U'
			multiple 'U'			
			transpose 'V'
			multiple 'V'			
		end
	end

end

Decomposer.new('A1',100).decompose
Decomposer.new('A2',2).decompose
Decomposer.new('A2',100).decompose
Decomposer.new('A3',2).decompose
Decomposer.new('A3',100).decompose
Decomposer.new('A4',100).decompose

Process.waitall

`R --vanilla < render_graphs.R`
