module LDraw
  class Comment < Struct.new(:comment)
    def to_s
      "0 #{comment}"
    end
  end
end
