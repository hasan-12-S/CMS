require_relative "spec_helper"

RSpec.describe Cms::CourseService, :p2p do
  let(:repo) { Cms::CourseRepo.new(tmp_store("courses.json")) }
  let(:svc)  { described_class.new(repo) }
  it "adds a course with unique code" do
    svc.add(code: "CS101", title: "Intro")
    expect { svc.add(code: "CS101", title: "Dup") }.to raise_error(Cms::ValidationError)
    expect(repo.count).to eq(1)
  end
end
