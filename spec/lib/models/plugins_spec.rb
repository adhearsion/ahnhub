require 'spec_helper'

describe Plugin do
  it "requires a timestampe" do
    p = Plugin.new(name: "foo")
    expect {p.save}.to raise_error StandardError
  end
end