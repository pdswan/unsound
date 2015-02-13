module Unsound
  module Control
    module_function

    def try(&blk)
      Data::Right.new(blk.call)
    rescue
      Data::Left.new($!)
    end
  end
end
