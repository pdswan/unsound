require "unsound/shared/functor_examples"
require "unsound/shared/monad_examples"

RSpec.describe Unsound::Data::Either do
  let(:value) { double(:value) }

  let(:instances) do
    [
      Unsound::Data::Right.new(value),
      Unsound::Data::Left.new(value)
    ]
  end

  it "has an abstract base class" do
    expect {
      Unsound::Data::Either.new("anything")
    }.to raise_error(NotImplementedError)
  end

  it_behaves_like "a Functor"

  it_behaves_like "a Monad" do
    let(:type) { Unsound::Data::Either }

    specify { expect(type.of(value)).to eq(Unsound::Data::Right.new(value)) }
  end
end
