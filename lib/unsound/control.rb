require "english"

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
      Data::Right.new(block.call)
    rescue
      Data::Left.new($ERROR_INFO)
    end
  end
end
