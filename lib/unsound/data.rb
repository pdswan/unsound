require "abstract_type"
require "concord"

module Unsound
  module Data
    # @abstract
    class Either
      include AbstractType
      include Concord::Public.new(:value)

      # Wraps a raw value in a {Data::Right}
      #
      # @param value [Any] the value to wrap
      # @return [Data::Right]
      def self.of(value)
        Right.new(value)
      end

      abstract_method :fmap
      abstract_method :>>

      abstract_method :either
      abstract_method :and_then
      abstract_method :or_else

      private

      def of(value)
        self.class.of(value)
      end
    end

    class Left < Either
      # A Noop
      #
      # @return [Data::Left]
      def fmap(*)
        self
      end

      # A Noop
      #
      # @return [Data::Left]
      def >>(*)
        self
      end
      alias :and_then :>>

      # Chain another operation which can result in a {Data::Either}
      #
      # @param f[#call] the next operation
      # @return [Data::Left, Data::Right]
      def or_else(f = nil, &blk)
        (f || blk)[value]
      end

      # Call a function on the value in the {Data::Left}
      #
      # @param f [#call] a function capable of processing the value
      # @param _ [#call] a function that will never be called
      def either(f, _)
        f[value]
      end
    end

    class Right < Either
      # Apply a function to a value contained in a {Data::Right}
      #
      # @param f [#call] the function to apply
      # @return [Data::Right] the result of applying the function
      #   wrapped in a {Data::Right}
      def fmap(f = nil, &blk)
        self >> Composition.compose(method(:of), (f || blk))
      end

      # Chain another operation which can result in a {Data::Either}
      #
      # @param f[#call] the next operation
      # @return [Data::Left, Data::Right]
      def >>(f = nil, &blk)
        (f || blk)[value]
      end
      alias :and_then :>>

      # A Noop
      #
      # @return [Data::Right]
      def or_else(*)
        self
      end

      # Call a function on the value in the {Data::Right}
      #
      # @param _ [#call] a function that will never be called
      # @param f [#call] a function capable of processing the value
      def either(_, f)
        f[value]
      end
    end
  end
end
