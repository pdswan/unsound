require "unsound"

RSpec.describe "Use cases" do
  let(:repo) do
    users.inject({ }) do |users, user|
      users.merge(user.id => user)
    end
  end

  let(:alice) { double(:alice, id: :alice, name: "Alice") }
  let(:voldemort) { double(:voldemort, id: :voldemort, name: nil) }
  let(:users) { [alice, voldemort] }

  let(:id) { ->(x) { x } }

  it "allows mapping over the value of a computation" do
    expect(
      Unsound::Control.try do
        repo.fetch(:alice)
      end.
      fmap(&:name).
      fmap(&:upcase)
    ).to eq(Unsound::Data::Right.new("ALICE"))
  end

  describe "error handling" do
    describe "a user is not found" do
      it "allows graceful error handling" do
        Unsound::Control.try do
          repo.fetch(:does_not_exist)
        end.
        fmap(&:name).
        fmap(&:upcase).either(
          ->(error) { expect(error).to be_kind_of(KeyError) },
          ->(_) { raise "Can't get here" }
        )
      end
    end

    describe "failures further down the chain" do
      it "allows graceful error handling" do
        Unsound::Control.try do
          repo.fetch(:voldemort)
        end.
        fmap(&:name).
        # TODO - this is verbose because try eagerly evaluates
        # is there a good way to make this more terse?
        and_then { |value| Unsound::Control.try { value.upcase } }.
        either(
          ->(error) { expect(error).to be_kind_of(NoMethodError) },
          ->(_) { raise "Can't get here" }
        )
      end
    end
  end
end
