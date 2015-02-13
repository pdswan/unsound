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

RSpec.shared_examples_for "a Monad" do
  let(:f) { ->(x) { [x, x] } }

  describe "left identity" do
    specify do
      expect(type.of(value) >> f).to eq(f[value])
    end
  end

  describe "right identity" do
    specify do
      instances.each do |instance|
        expect(instance >> type.public_method(:of)).to eq(instance)
      end
    end
  end

  describe "associativity" do
    pending
  end
end

RSpec.describe Unsound::Data::Either do
  let(:value) { double(:value) }

  let(:instances) do
    [
      Unsound::Data::Right.new(value),
      Unsound::Data::Left.new(value)
    ]
  end

  it_behaves_like "a Functor"

  it_behaves_like "a Monad" do
    let(:type) { Unsound::Data::Either }

    specify { expect(type.of(value)).to eq(Unsound::Data::Right.new(value)) }
  end
end
