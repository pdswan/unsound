require "shared/functor_examples"
require "shared/monad_examples"

require "unsound"

RSpec.describe Unsound::Data::Maybe do
  let(:value) { double(:value) }

  let(:instances) do
    [
      Unsound::Data::Nothing.new,
      Unsound::Data::Just.new(value)
    ]
  end

  it "has an abstract base class" do
    expect {
      Unsound::Data::Maybe.new
    }.to raise_error(NotImplementedError)
  end

  it_behaves_like "a Functor"

  it_behaves_like "a Monad" do
    let(:type) { Unsound::Data::Maybe }

    specify { expect(type.of(value)).to eq(Unsound::Data::Just.new(value)) }
  end

  describe "#and_then" do
    let(:and_then) do
      ->(value) { Unsound::Data::Just.new([value, value]) }
    end

    context "a just" do
      let(:just) { Unsound::Data::Just.new(value) }
      let(:value) { double(:value) }

      context "a function" do
        it "applies the function over the value" do
          expect(just.and_then(and_then)).to eq(and_then.call(value))
        end
      end

      context "a block" do
        it "applies the block over the value" do
          expect(just.and_then(&and_then)).to eq(and_then.call(value))
        end
      end
    end

    context "a nothing" do
      let(:nothing) { Unsound::Data::Nothing.new }
      let(:error) { double(:error) }

      it "is a noop returning self" do
        expect(nothing.and_then(and_then)).to eq(nothing)
      end
    end
  end

  describe "#or_else" do
    let(:or_else) do
      -> { Unsound::Data::Nothing.new }
    end

    context "a just" do
      let(:just) { Unsound::Data::Right.new(value) }
      let(:value) { double(:value) }

      it "is a noop returning self" do
        expect(just.or_else(or_else)).to eq(just)
      end
    end

    context "a nothing" do
      let(:nothing) { Unsound::Data::Nothing.new }

      context "a function" do
        it "calls the function" do
          expect(nothing.or_else(or_else)).to eq(or_else.call)
        end
      end

      context "a block" do
        it "yields to the block" do
          expect(nothing.or_else(&or_else)).to eq(or_else.call)
        end
      end
    end
  end

  describe "#maybe" do
    let(:just_fn) { double(:just_fn) }
    let(:nothing_fn) { double(:nothing_fn) }

    let(:just_result) { double(:just_result) }
    let(:nothing_result) { double(:nothing_result) }

    context "a just" do
      let(:just) { Unsound::Data::Just.new(value) }

      it "calls the just function with the value" do
        allow(just_fn).to receive(:[]).
          with(value).and_return(just_result)
        expect(just.maybe(just_fn, nothing_fn)).to eq(just_result)
      end
    end

    context "a nothing" do
      let(:nothing) { Unsound::Data::Nothing.new }

      it "calls the nothing function" do
        allow(nothing_fn).to receive(:[]).and_return(nothing_result)
        expect(nothing.maybe(just_fn, nothing_fn)).to eq(nothing_result)
      end
    end
  end
end
