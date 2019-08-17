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
  def parser
    @parser ||= OptionParser.new.tap do |op|
    end
  end
end

SnapToGrid.new(ARGV).run
