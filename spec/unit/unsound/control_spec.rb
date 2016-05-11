require "unsound"

RSpec.describe Unsound::Control do
  describe Unsound::Control, ".try" do
    subject(:run_try) { Unsound::Control.try(&blk) }

    context "the block executes successfully" do
      let(:blk) { -> { result } }
      let(:result) { double(:result) }

      it "returns the result of the block wrapped in a Right" do
        expect(run_try).to be_a(Unsound::Data::Right)
        expect(run_try.value).to eq(result)
      end
    end

    context "the block raises an exception" do
      let(:blk) { -> { fail error } }
      let(:error) { StandardError.new("Something went wrong") }

      it "returns the exception wrapped in a Left" do
        expect(run_try).to be_a(Unsound::Data::Left)
        expect(run_try.value).to eq(error)
      end
    end
  end

  describe Unsound::Control, ".wrap_with_try" do
    subject(:wrapped_try) { Unsound::Control.wrap_with_try(&blk) }

    context "the block executes successfully" do
      let(:blk) { ->(argument) { result } }
      let(:result) { double(:result) }

      it "returns the result wrapped in a Right when it is called" do
        result_of_call = wrapped_try.call("foo")
        expect(result_of_call).to be_a(Unsound::Data::Right)
        expect(result_of_call.value).to eq(result)
      end
    end

    context "the block raises an exception" do
      let(:blk) { ->(argument) { fail error } }
      let(:error) { StandardError.new("Something went wrong") }

      it "returns the exception wrapped in a Left when it is called" do
        result_of_call = wrapped_try.call("foo")
        expect(result_of_call).to be_a(Unsound::Data::Left)
        expect(result_of_call.value).to eq(error)
      end
    end
  end

  describe Unsound::Control, ".maybe" do
    subject(:run_maybe) { Unsound::Control.maybe(&blk) }

    context "the block returns nil" do
      let(:blk) { -> { nil } }

      it "returns Nothing" do
        expect(run_maybe).to be_a(Unsound::Data::Nothing)
      end
    end

    context "the block does not return nil" do
      let(:blk) { -> { result } }
      let(:result) { double(:result) }

      it "returns a Just" do
        expect(run_maybe).to be_a(Unsound::Data::Just)
        expect(run_maybe.value).to eq(result)
      end
    end
  end

  describe Unsound::Control, ".wrap_with_maybe" do
    subject(:wrapped_maybe) { Unsound::Control.wrap_with_maybe(&blk) }

    context "the block returns nil" do
      let(:blk) { ->(argument) { nil } }

      it "returns Nothing when it is called" do
        result_of_call = wrapped_maybe.call("foo")
        expect(result_of_call).to be_a(Unsound::Data::Nothing)
      end
    end

    context "the block does not return nil" do
      let(:blk) { ->(argument) { result } }
      let(:result) { double(:result) }

      it "returns the result wrapped in a Just when it is called" do
        result_of_call = wrapped_maybe.call("foo")
        expect(result_of_call).to be_a(Unsound::Data::Just)
        expect(result_of_call.value).to eq(result)
      end
    end
  end
end
