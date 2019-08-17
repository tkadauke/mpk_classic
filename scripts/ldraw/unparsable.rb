module LDraw
  class Unparsable < Struct.new(:content)
    def to_s
      content
    end
  end
end
