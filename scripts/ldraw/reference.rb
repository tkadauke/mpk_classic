module LDraw
  class Reference < Struct.new(:color, :x, :y, :z, :a, :b, :c, :d, :e, :f, :g, :h, :i, :file)
    def to_s
      "1 #{color} #{x} #{y} #{z} #{a} #{b} #{c} #{d} #{e} #{f} #{g} #{h} #{i} #{file}"
    end
  end
end
