require "abstract_type"
require "concord"

module Unsound
  module Data
    class Either
      include AbstractType
      include Concord::Public.new(:value)

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
      def fmap(_)
        self
      end

      def >>(_)
        self
      end
    end

    class Right < Either
      def fmap(f)
        self >> Composition.compose(method(:of), f)
      end

      def >>(f)
        f[value]
      end
    end
  end
end
