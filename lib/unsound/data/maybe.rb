require "abstract_type"
require "equalizer"

module Unsound
  module Data
    # @abstract
    class Maybe
      include AbstractType

      # Wraps a raw value in a {Data::Just}
      #
      # @param value [Any] the value to wrap
      # @return [Data::Just]
      def self.of(value)
        Just.new(value)
      end

      abstract_method :fmap
      abstract_method :>>

      abstract_method :maybe
      abstract_method :and_then
      abstract_method :or_else

      private

      def of(value)
        self.class.of(value)
      end
    end

    class Nothing < Maybe
      include Equalizer.new

      # A Noop
      #
      # @return [Data::Nothing]
      def fmap(*)
        self
      end

      # A Noop
      #
      # @return [Data::Nothing]
      def >>(*)
        self
      end
      alias :and_then :>>

      # Chain another operation which can result in a {Data::Maybe}
      #
      # @param f[#call] the next operation
      # @return [Data::Nothing, Data::Just]
      def or_else(f = nil, &blk)
        (f || blk).call
      end

      # Call the specified function with no arguments
      #
      # @param _ [#call] a function that will never be called
      # @param f [#call] a function that takes no arguments
      def maybe(_, f)
        f[]
      end
    end

    class Just < Maybe
      include Concord::Public.new(:value)

      # Apply a function to a value contained in a {Data::Just}
      #
      # @param f [#call] the function to apply
      # @return [Data::Just] the result of applying the function
      #   wrapped in a {Data::Just}
      def fmap(f = nil, &blk)
        self >> Composition.compose(method(:of), (f || blk))
      end

      # Chain another operation which can result in a {Data::Maybe}
      #
      # @param f[#call] the next operation
      # @return [Data::Nothing, Data::Just]
      def >>(f = nil, &blk)
        (f || blk)[value]
      end
      alias :and_then :>>

      # A Noop
      #
      # @return [Data::Just]
      def or_else(*)
        self
      end

      # Call a function on the value in the {Data::Just}
      #
      # @param f [#call] a function capable of processing the value
      # @param _ [#call] a function that will never be called
      def maybe(f, _)
        f[value]
      end
    end
  end
end
