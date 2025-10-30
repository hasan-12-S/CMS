require_relative "spec_helper"

RSpec.describe Cms::JsonStore, :p2p do
  it "round trips items" do
    s = tmp_store("rt.json")
    s.write_all([{ "id" => 1, "x" => 2 }])
    expect(s.read_all).to eq([{ "id"=>1, "x"=>2 }])
  end
end
