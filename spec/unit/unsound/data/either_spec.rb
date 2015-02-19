require "shared/functor_examples"
require "shared/monad_examples"

require "unsound"

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

  describe "#or_else" do
    let(:or_else) do
      ->(error) { Unsound::Data::Left.new(or_else_result) }
    end
    let(:or_else_result) { double(:or_else_result) }

    context "a right" do
      let(:right) { Unsound::Data::Right.new(value) }
      let(:value) { double(:value) }

      it "is a noop returning self" do
        expect(right.or_else(or_else)).to eq(right)
      end
    end

    context "a left" do
      let(:left) { Unsound::Data::Left.new(error) }
      let(:error) { double(:error) }

      it "applies the function over the error" do
        expect(left.or_else(or_else)).to eq(or_else.call(error))
      end
    end
  end

  describe "#either" do
    let(:left_fn) { double(:left_fn) }
    let(:right_fn) { double(:right_fn) }

    let(:left_result) { double(:left_result) }
    let(:right_result) { double(:right_result) }

    context "a right" do
      let(:right) { Unsound::Data::Right.new(value) }

      it "calls the right function with the value" do
        allow(right_fn).to receive(:[]).
          with(value).and_return(right_result)
        expect(right.either(left_fn, right_fn)).to eq(right_result)
      end
    end

    context "a left" do
      let(:left) { Unsound::Data::Left.new(value) }

      it "calls the left function with the value" do
        allow(left_fn).to receive(:[]).
          with(value).and_return(left_result)
        expect(left.either(left_fn, right_fn)).to eq(left_result)
      end
    end
  end
end
