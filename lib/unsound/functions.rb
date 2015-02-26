module Unsound
  module Functions
    class Lazy
      [:==, :"!=", :equal?, :is_a?, :kind_of?, :inspect, :to_s].each do |method|
        undef_method method
      end

      def initialize(*args, &blk)
        @curried_args = args.dup
        @fn = blk || curried_args.pop
      end

      def curry(*args)
        Lazy.new(*(curried_args + args), fn)
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
