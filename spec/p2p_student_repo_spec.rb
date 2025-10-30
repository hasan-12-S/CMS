require_relative "spec_helper"

RSpec.describe Cms::StudentRepo, :p2p do
  let(:repo) { described_class.new(tmp_store("students.json")) }
  it "creates and finds by email" do
    repo.create(name: "A", email: "a@example.com", active: true)
    repo.create(name: "B", email: "b@example.com", active: true)
    expect(repo.find_by_email("B@EXAMPLE.COM")[:name]).to eq("B")
  end
  it "lists only active students" do
    repo.create(name: "A", email: "a@x", active: true)
    repo.create(name: "B", email: "b@x", active: false)
    expect(repo.active.map { |s| s[:name] }).to eq(["A"])
  end
end
