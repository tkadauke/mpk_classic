require_relative 'comment'
require_relative 'ext_reference'
require_relative 'line'
require_relative 'optional_line'
require_relative 'quadrilateral'
require_relative 'reference'
require_relative 'triangle'
require_relative 'unparsable'

module Enumerable
  def map_first(&block)
    each do |element|
      result = block.call(element)
      return result if result
    end
    nil
  end
end

module LDraw
  class File
    INT = /[+-]?\d+/
    FLOAT = /[+-]?\d+(?:\.\d+(?:e[\+\-\d+])?)?/
    FILE = /[\w\d\-\.\s\/]+/
    FLAG = /(?:True|False)/
    PARSER = {
      /^0 (.*)$/ => Comment,
      /^1 (#{INT}) (#{FLOAT}) (#{FLOAT}) (#{FLOAT}) (#{FLOAT}) (#{FLOAT}) (#{FLOAT}) (#{FLOAT}) (#{FLOAT}) (#{FLOAT}) (#{FLOAT}) (#{FLOAT}) (#{FLOAT}) (#{FILE})$/ => Reference,
      /^2 (#{INT}) (#{FLOAT}) (#{FLOAT}) (#{FLOAT}) (#{FLOAT}) (#{FLOAT}) (#{FLOAT})$/ => Line,
      /^3 (#{INT}) (#{FLOAT}) (#{FLOAT}) (#{FLOAT}) (#{FLOAT}) (#{FLOAT}) (#{FLOAT}) (#{FLOAT}) (#{FLOAT}) (#{FLOAT})$/ => Triangle,
      /^4 (#{INT}) (#{FLOAT}) (#{FLOAT}) (#{FLOAT}) (#{FLOAT}) (#{FLOAT}) (#{FLOAT}) (#{FLOAT}) (#{FLOAT}) (#{FLOAT}) (#{FLOAT}) (#{FLOAT}) (#{FLOAT})$/ => Quadrilateral,
      /^5 (#{INT}) (#{FLOAT}) (#{FLOAT}) (#{FLOAT}) (#{FLOAT}) (#{FLOAT}) (#{FLOAT}) (#{FLOAT}) (#{FLOAT}) (#{FLOAT}) (#{FLOAT}) (#{FLOAT}) (#{FLOAT})$/ => OptionalLine,
      /^10 (#{INT}) (#{FLAG}) (#{INT}) (#{FLOAT}) (#{FLOAT}) (#{FLOAT}) (#{FLOAT}) (#{FLOAT}) (#{FLOAT}) (#{FLOAT}) (#{FLOAT}) (#{FLOAT}) (#{FLOAT}) (#{FLOAT}) (#{FLOAT}) (#{FILE})$/ => ExtReference,
      /^.*$/ => Unparsable,
    }
    FIELD_PARSER = {
      /^#{INT}$/ => :to_i,
      /^#{FLOAT}$/ => :to_f,
      /.*/ => :to_s
    }

    attr_accessor :name
    attr_accessor :directives
  
    def initialize(name)
      self.name = name
      self.parse
    end

    def parse
      ::File.open(name, "r:bom|utf-8") do |file|
        @directives = file.read.split(/[\r\n]+/).each_with_index.map do |directive, i|
          PARSER.map_first do |regexp, cls|
            cls.new(*Regexp.last_match.captures.map do |arg|
              FIELD_PARSER.map_first do |fregexp, method|
                arg.send(method) if fregexp =~ arg 
              end
            end).tap do |dir|
              puts "WARNING: Could not parse line #{i}: `#{directive}`" if dir.is_a?(LDraw::Unparsable)
            end if regexp =~ directive
          end
        end
      end
    end
  
    def to_s
      directives.map(&:to_s).join("\n")
    end
  
    def write
      ::File.open(name, "w") do |file|
        directives.each do |directive|
          file.puts(directive.to_s)
        end
      end
    end
  end
end
