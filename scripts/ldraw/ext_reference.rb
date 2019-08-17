module LDraw
  class ExtReference < Struct.new(:color, :unkn_flag, :unkn_int, :x, :y, :z, :a, :b, :c, :d, :e, :f, :g, :h, :i, :file)
    def to_s
      "10 #{color} #{unkn_flag} #{unkn_int} #{x} #{y} #{z} #{a} #{b} #{c} #{d} #{e} #{f} #{g} #{h} #{i} #{file}"
    end
  end
end
