#!/usr/bin/env ruby
MIN_TERMS_PER_DOC = 30

STDIN.each do |line|
  url, date, text = line.chomp.split '|'
  next unless text.split.size > MIN_TERMS_PER_DOC

  terms = text.gsub(/[^a-zA-Z0-9 ]/,' ').
    split(/\s+/).
    select { |w| w.length >1 }.
    collect { |w| w.downcase.to_sym }

  terms.each { |t| puts t }
end
