module LDraw
  class Triangle < Struct.new(:color, :x1, :y1, :z1, :x2, :y2, :z2, :x3, :y3, :z3)
    def to_s
      "3 #{color} #{x1} #{y1} #{z1} #{x2} #{y2} #{z2} #{x3} #{y3} #{z3}"
    end
  end
end
