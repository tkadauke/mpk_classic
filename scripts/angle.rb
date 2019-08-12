#!/usr/bin/env ruby
require 'optparse'

class Point
  attr_accessor :x, :y
  
  def initialize(x, y)
    self.x = x
    self.y = y
  end
  
  def rotate(degrees)
    cosd = Math.cos(degrees)
    sind = Math.sin(degrees)
    Point.new(
      x * cosd - y * sind,
      y * cosd + x * sind
    )
  end
  
  def floor
    Point.new(x.floor, y.floor)
  end
  
  def round(precision)
    Point.new(x.round(precision), y.round(precision))
  end
  
  def to_s
    "(#{x}, #{y})"
  end
end


class AngleCalculator
  EPSILON = 0.05
  # take wirdth and height as arguments
  attr_accessor :angle, :width, :height
  
  def initialize(argv)
    parser.parse(argv)
  end

  def run
    radians = (angle || 45).to_f * Math::PI / 180.0
    
    (0..(self.height || 16)).step(0.5) do |y|
      (0..(self.width || 16)).step(0.5) do |x|
        # studs are centered between whole integer numbers
        point = Point.new(x + 0.5, y + 0.5)
        # rotate around origin
        rotated = point.rotate(radians)
        
        if on_stud(rotated)
          puts "#{point} -> #{rotated.round(1)}"
        end
      end
    end
  end

private
  def parser
    @parser ||= OptionParser.new.tap do |op|
      op.on("--angle N", Float, "Hinge angle") do |n|
        self.angle = n
      end
      
      op.on("--width N", Integer, "Width in studs") do |n|
        self.width = n
      end
      
      op.on("--height N", Integer, "Height in studs") do |n|
        self.height = n
      end
    end
  end
  
  def fraction(number)
    number.abs - number.abs.floor
  end
  
  def on_stud(point)
    coord_on_stud(point.x) && coord_on_stud(point.y)
  end
  
  def coord_on_stud(coord)
    (fraction(coord) - 0.5).abs < AngleCalculator::EPSILON
  end
end

AngleCalculator.new(ARGV).run
