module Unsound
  module Functions
    class Lazy
      [:==, :"!=", :equal?].each do |method|
        undef_method method
      end

      def initialize(fn, *curried_args)
        @fn = fn
        @curried_args = curried_args
      end

      def curry(*args)
        self.class.new(fn, *(curried_args + args))
      end
      alias :[] :curry
      alias :call :curry

      def method_missing(method, *args, &blk)
        result.public_send(method, *args, &blk)
      end

      def to_proc
        public_method(:curry).to_proc
      end

      private

      def result
        @result ||= fn[*curried_args]
      end

      attr_reader :curried_args
      attr_reader :fn
    end
  end
end
