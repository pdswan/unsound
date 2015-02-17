require "abstract_type"
require "concord"

module Unsound
  module Data
    # @abstract
    class Either
      include AbstractType
      include Concord::Public.new(:value)

      # Wraps a raw value in a Unsound::Data::Right
      #
      # @param value [Any] the value to wrap
      # @return [Data::Right]
      def self.of(value)
        Right.new(value)
      end

      abstract_method :fmap

      private

      def of(value)
        self.class.of(value)
      end
    end

    class Left < Either
      # A Noop
      # @return [Data::Left]
      def fmap(_)
        self
      end

      # A Noop
      # @return [Data::Left]
      def >>(_)
        self
      end

      # Call a function on the value in the Data::Left
      #
      # @param f [Proc] a function capable of processing the value
      # @param _ [Proc] a function that will never be called
      def either(f, _)
        f[value]
      end
    end

    class Right < Either
      # Apply a function to a value contained in a Data::Right
      #
      # @param f [#call] the function to apply
      # @return [Data::Right] the result of applying the function
      #   wrapped in a Data::Right
      def fmap(f)
        self >> Composition.compose(method(:of), f)
      end

      # Chain another operation which can result in a Data::Either
      #
      # @param f[#call] the next operation
      # @return [Data::Left, Data::Right]
      def >>(f)
        f[value]
      end

      # Call a function on the value in the Data::Right
      #
      # @param _ [Proc] a function that will never be called
      # @param f [Proc] a function capable of processing the value
      def either(_, f)
        f[value]
      end
    end
  end
end
