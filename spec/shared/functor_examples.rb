RSpec.shared_examples_for "a Functor" do
  let(:id) { ->(x) { x } }
  let(:dbl) { ->(x) { [x, x] } }
  let(:compose) { Unsound::Composition.public_method(:compose) }

  describe "fmap" do
    specify do
      instances.each do |instance|
        expect(instance.fmap(id)).to eq(id[instance])
      end
    end

    specify do
      instances.each do |instance|
        expect(
          instance.fmap(dbl).fmap(dbl)
        ).to eq(
          instance.fmap(compose[dbl, dbl])
        )
      end
    end
  end
end
