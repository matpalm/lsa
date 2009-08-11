#!/usr/bin/env ruby
raise "run.rb LINES <FILE> <MIN_TERMS_PER_LINE>" unless ARGV.length>=1 and ARGV.length<=3

LINES = ARGV.shift
FILE = (ARGV.shift unless ARGV.empty?) || 'web_content'
MIN_TERMS_PER_LINE = (ARGV.shift.to_i unless ARGV.empty?) || 30
puts "LINES=#{LINES} FILE=#{FILE} MIN_TERMS_PER_LINE=#{MIN_TERMS_PER_LINE}"

DIR = "#{LINES}_"

FORK = false

def run cmd
	start = Time.now
	out = "#{cmd} "
	out += `#{cmd}`.chomp
	time = Time.now - start
	out += " took #{time}s"
	puts out
end

def fork_if_configured
	FORK ? fork { yield } : yield
end

run "mkdir #{DIR}"
run "head -n #{LINES} #{FILE} | ./feed_to_occurrence_matrix.rb #{DIR} #{MIN_TERMS_PER_LINE}"
run "./tf_idf_sparse.rb < #{DIR}/tom.sparse.raw > #{DIR}/tom.sparse.tf_idf"

def vsm_similar type
	fork_if_configured do
		run "./find_similar_sparse.rb < #{DIR}/tom.sparse.#{type} > #{DIR}/tomv.similar.#{type}"
	end
end

def svd_similar type
	fork_if_configured do
		run "./svd -d 50 -v 0 -o #{DIR}/svd.#{type} #{DIR}/tom.sparse.#{type}"
		run "./transpose < #{DIR}/svd.#{type}-Vt > #{DIR}/svd.#{type}-V"
		run "./find_similar_dense.rb < #{DIR}/svd.#{type}-V > #{DIR}/svd.similar.#{type}"
	end
end

vsm_similar 'raw'
vsm_similar 'tf_idf'
svd_similar 'raw'
svd_similar 'tf_idf'

Process.waitall
