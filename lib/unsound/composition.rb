module Unsound
  module Composition
    module_function

    # Compose two callables together
    #
    # g(f(x)) == (g * f)(x)
    #
    # @param g [#call] a lambda, proc, method, etc.
    # @param f [#call] a lambda, proc, method, etc.
    # @return [Proc]
    def compose(g, f)
      ->(*args)  { g.call(f.call(*args)) }
    end
  end
end
