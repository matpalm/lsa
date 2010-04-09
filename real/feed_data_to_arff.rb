#!/usr/bin/env ruby
puts <<EOF
@RELATION feed_data

@ATTRIBUTE content string
@ATTRIBUTE url string

@DATA
EOF

STDIN.each do |line|
  url,date,text = line.chomp.gsub(/[,"]/,' ').split('|')[0,3].collect{|f| %{"#{f}"}}
  puts [text,url].join(',')
end
