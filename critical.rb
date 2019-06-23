#!/usr/bin/env ruby
require 'chunky_png'

p = ChunkyPNG::Image.from_file ARGV[0]
debug = ARGV[1] == "debug"

iw = ih = p.width
pw = ph = iw / 32
ox = oy = pw / 2
b = ""
t = 0.25
c = 0
w = 1

(oy..ih).step(ph).each do |y|
	(ox..iw).step(pw).each do |x|
		p1 = p[x-11,y-1]
		p2 = p[x-11,y+1]
		s1 = ChunkyPNG::Color.to_hsb(p1)[2]
		s2 = ChunkyPNG::Color.to_hsb(p2)[2]
		r = ((s1 >= t) and (s2 >= t)) ? "1" : "0"
		b += r
		c += 1
		puts "DEBUG #{w},#{c}: #{r} <- #{s1}, #{s2}" if debug
		if debug and c == 8
			c = 0
			w += 1
			puts "----------------------------------------"
		end
	end
end

b.scan(/\d{8}/).each{|w| print w.to_i(2).chr}
puts ""
