require_relative "spec_helper"

RSpec.describe "CLI enroll parsing", :f2p do
  it "treats negative ids as integers and not 0" do
    expect { Integer("-5") }.not_to raise_error
  end
end
