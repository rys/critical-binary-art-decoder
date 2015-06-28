#!/usr/bin/env ruby
require 'chunky_png'

p = ChunkyPNG::Image.from_file ARGV[0]

iw = ih = p.width
pw = ph = iw / 32
ox = oy = pw / 2
t = 16843263
b = ""

(oy..ih).step(ph).each do |y|
	(ox..iw).step(pw).each do |x|
		b += ChunkyPNG::Color.to_grayscale(p[x,y]) <= t ? "0" : "1"
	end
end

b.scan(/\d{8}/).each{|w| print w.to_i(2).chr}
puts ""
