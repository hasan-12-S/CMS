require_relative "spec_helper"

RSpec.describe "ReportService#gpa", :p2p do
  let(:srepo) { Cms::StudentRepo.new(tmp_store("s.json")) }
  let(:crepo) { Cms::CourseRepo.new(tmp_store("c.json")) }
  let(:erepo) { Cms::EnrollmentRepo.new(tmp_store("e.json")) }
  let(:svc)   { Cms::ReportService.new(student_repo: srepo, course_repo: crepo, enrollment_repo: erepo) }

  before do
    srepo.create(name: "Hanzala", email: "h@x", active: true)
    crepo.create(code: "MATH", title: "Math")
    crepo.create(code: "PHY", title: "Physics")
    erepo.create(student_id: 1, course_id: 1, grade: "A")
    erepo.create(student_id: 1, course_id: 2, grade: "B")
  end

  it "calculates correct GPA" do
    expect(svc.gpa(1)).to eq(3.5)
  end

  it "returns nil if no grades yet" do
    expect(svc.gpa(999)).to be_nil
  end
end
