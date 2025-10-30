require_relative "spec_helper"

RSpec.describe Cms::ReportService, :p2p do
  let(:srepo) { Cms::StudentRepo.new(tmp_store("s.json")) }
  let(:crepo) { Cms::CourseRepo.new(tmp_store("c.json")) }
  let(:erepo) { Cms::EnrollmentRepo.new(tmp_store("e.json")) }
  let(:svc)   { described_class.new(student_repo: srepo, course_repo: crepo, enrollment_repo: erepo) }
  before do
    srepo.create(name: "A", email: "a@x", active: true)
    srepo.create(name: "B", email: "b@x", active: true)
    crepo.create(code: "C1", title: "Course1")
    crepo.create(code: "C2", title: "Course2")
    erepo.create(student_id: 1, course_id: 1)
    erepo.create(student_id: 2, course_id: 2)
  end
  it "roster lists students for a course" do
    expect(svc.roster(1).map { |s| s[:name] }).to eq(["A"])
  end
  it "schedule lists courses for a student" do
    expect(svc.schedule(2).map { |c| c[:code] }).to eq(["C2"])
  end
end
