module LDraw
  class Line < Struct.new(:color, :x1, :y1, :z1, :x2, :y2, :z2)
    def to_s
      "2 #{color} #{x1} #{y1} #{z1} #{x2} #{y2} #{z2}"
    end
  end
end
