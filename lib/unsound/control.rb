require "English"

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

    # Execute the block. If the block
    # results in Nil, return {Data::Nothing},
    # otherwise wrap the result in a {Data::Just}
    #
    # @param block [Block] the block to execute
    # @return [Data::Nothing, Data::Just] an instance of {Data::Maybe}
    def maybe(&block)
      if (result = block.call).nil?
        Data::Nothing.new
      else
        Data::Just.new(result)
      end
    end
  end
end
