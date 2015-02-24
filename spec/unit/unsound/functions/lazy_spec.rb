require 'unsound'

RSpec.describe Unsound::Functions::Lazy do
  let(:fn) do
    ->(a, b, c) { [a, b, c] }
  end

  let(:exceptional_fn) do
    ->(a) { raise ArgumentError, "You gave me #{a.inspect}?!" }
  end

  let(:lazy_fn) do
    Unsound::Functions::Lazy.new(fn)
  end

  let(:lazy_exceptional_fn) do
    Unsound::Functions::Lazy.new(exceptional_fn)
  end

  def yields_to_block(&blk)
    yield 1, 2, 3
  end

  def calls_block(&blk)
    blk.call(2, 3, 4)
  end

  it "acts just like the underlying function when called" do
    expect(lazy_fn.call(1, 2, 3)).to eq fn.call(1, 2, 3)
  end

  it "can be curried" do
    expect(lazy_fn.curry(1, 2).call(3)).to eq fn.call(1, 2, 3)
    expect(lazy_fn[1][2].call(3)).to eq fn.call(1, 2, 3)
    expect(lazy_fn[1][2][3]).to eq fn.call(1, 2, 3)
  end

  it "is only executed when the value is needed" do
    expect {
      lazy_exceptional_fn.curry(1)
    }.to_not raise_error

    expect {
      puts lazy_exceptional_fn.curry(1)
    }.to raise_error ArgumentError
  end

  it "can be used in place of a block" do
    expect(yields_to_block(&lazy_fn)).to eq [1, 2, 3]
    expect(calls_block(&lazy_fn)).to eq [2, 3, 4]
  end
end
