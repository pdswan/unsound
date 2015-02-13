module Unsound
  module Composition
    module_function

    def compose(f, g)
      ->(*args)  { f.call(g.call(*args)) }
    end
  end
end
