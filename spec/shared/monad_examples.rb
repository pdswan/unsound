RSpec.shared_examples_for "a Monad" do
  let(:f) { ->(x) { type.of([x, x]) } }

  describe "having left identity" do
    specify do
      expect(type.of(value) >> f).to eq(f[value])
    end
  end

  describe "having right identity" do
    specify do
      instances.each do |instance|
        expect(instance >> type.public_method(:of)).to eq(instance)
      end
    end
  end

  describe "having associativity" do
    specify do
      instances.each do |instance|
        expect(
          instance >> ->(a) {
            f[a] >> ->(b) {
              f[b]
            }
          }
        ).to eq(instance >> f >> f)
      end
    end
  end
end
