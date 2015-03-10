RSpec.shared_examples_for "a Functor" do
  let(:id) { ->(x) { x } }
  let(:dbl) { ->(x) { [x, x] } }
  let(:fst) { ->(xs) { xs.first } }
  let(:compose) { Unsound::Composition.public_method(:compose) }

  describe "fmap" do
    describe "identity" do
      specify do
        instances.each do |instance|
          expect(instance.fmap(id)).to eq(id[instance])
        end
      end
    end

    describe "composition" do
      specify do
        instances.each do |instance|
          expect(
            instance.fmap(dbl).fmap(fst)
          ).to eq(
            instance.fmap(compose[fst, dbl])
          )
        end
      end
    end
  end
end
