#!/usr/bin/env ruby
require 'cgi'

Row = Struct.new :id, :url, :features

records = []
STDIN.each do |line|
  cols = line.split
  id = cols.shift
  url = cols.shift
  records << Row.new(id, CGI.escapeHTML(url), cols)
end

puts <<EOF
<?xml version="1.0"?>
<!DOCTYPE ggobidata SYSTEM "ggobi.dtd">
<ggobidata count="1">
<data>
EOF

number_dimensions = records.first.features.size

puts %{<variables count="#{number_dimensions+1}">}
puts %{<categoricalvariable name="url" levels="auto"/>}
number_dimensions.times do |d|
  puts %{ <realvariable name="f#{d+1}"/>}
end
puts %{</variables>}

puts %{<records count="#{records.size}" glyph="fc 1" color="1">}

records.each do |record|
  puts %{<record label="#{record.id}">}
  puts %{<string>#{record.url}</string>}
  record.features.each { |pt| print %{<real>#{pt}</real>} }; puts
  puts %{</record>}
end

puts <<EOF
</records>
</data>
</ggobidata>
EOF

