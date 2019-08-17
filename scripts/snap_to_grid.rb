#!/usr/bin/env ruby
require 'optparse'

require_relative 'ldraw/file'

class SnapToGrid
  def initialize(argv)
    parser.parse(argv)
  end

  def run
    file = LDraw::File.new(ARGV.pop)

    eof = 0
    file.directives.each do |directive|
      if directive.is_a?(LDraw::Reference) || directive.is_a?(LDraw::ExtReference)
        # Remove any rotation
        %i{a b c d e f g h i}.each do |coord|
          directive.send(:"#{coord}=", directive.send(coord).round)
        end
        
        # snap to closest half-stud
        directive.x = (directive.x / 10.0).round * 10.0
        directive.z = (directive.z / 10.0).round * 10.0
        # snap to closest plate height
        directive.y = (directive.y / 8.0).round * 8.0
      elsif directive.is_a?(LDraw::Comment) && directive.comment =~ /NOFILE/
        eof += 1
        # We need to look for the second NOFILE, since the header already ends with it
        break if eof == 2
      end
    end

    # puts file.to_s
    file.write
  end

private
  def help
    <<~end
      Usage: #{$0} FILE
      
      This script will snap all the pieces of an LDraw model to a grid. The grid
      is half-stud width in the x and z direction, and plate height in the y
      direction. It will also align all rotations to the axes. Note that this
      only makes sense for a model that doesn't have any angles; If your model
      does have intentional angles, the results of this script will most likely
      be undesirable.
    end
  end
  
  def parser
    @parser ||= OptionParser.new.tap do |op|
      op.banner = help
    end
  end
end

SnapToGrid.new(ARGV).run
