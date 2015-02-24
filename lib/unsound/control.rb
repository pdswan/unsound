module Unsound
  module Control
    module_function

    # Try executing the block. If the block
    # raises an exception wrap it in a {Data::Left},
    # otherwise wrap it in a {Data::Right}.
    #
    # @param block [Block] the block to execute
    # @return [Data::Right, Data::Left] an instance of
    #   a {Data::Right} or {Data::Left} to indicate success or failure.
    def try(&block)
      Functions::Lazy.new do |*args|
        begin
          Data::Right.new(block.call(*args))
        rescue
          Data::Left.new($!)
        end
      end
    end
  end
end
