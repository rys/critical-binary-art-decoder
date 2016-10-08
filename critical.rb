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
		p1 = p[x-11,y-1]
		p2 = p[x-11,y+1]
		t = 0.3
		b += ((ChunkyPNG::Color.to_hsb(p1)[2] >= t) and (ChunkyPNG::Color.to_hsb(p2)[2] >= t)) ? "1" : "0"
	end
end

b.scan(/\d{8}/).each{|w| print w.to_i(2).chr}
puts ""
