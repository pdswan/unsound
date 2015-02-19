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
      let(:blk) { -> { raise error } }
      let(:error) { StandardError.new("Something went wrong") }

      it "returns the exception wrapped in a Left" do
        expect(run_try).to be_a(Unsound::Data::Left)
        expect(run_try.value).to eq(error)
      end
    end
  end
end
