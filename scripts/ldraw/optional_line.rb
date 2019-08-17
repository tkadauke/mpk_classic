module LDraw
  class OptionalLine < Struct.new(:color, :x1, :y1, :z1, :x2, :y2, :z2, :x3, :y3, :z3, :x4, :y4, :z4)
    def to_s
      "5 #{color} #{x1} #{y1} #{z1} #{x2} #{y2} #{z2} #{x3} #{y3} #{z3} #{x4} #{y4} #{z4}"
    end
  end
end
