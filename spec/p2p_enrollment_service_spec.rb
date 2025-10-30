require_relative "spec_helper"

RSpec.describe Cms::EnrollmentService, :f2p do
  let(:srepo) { Cms::StudentRepo.new(tmp_store("s.json")) }
  let(:crepo) { Cms::CourseRepo.new(tmp_store("c.json")) }
  let(:erepo) { Cms::EnrollmentRepo.new(tmp_store("e.json")) }
  let(:svc)   { described_class.new(erepo, student_repo: srepo, course_repo: crepo) }
  before do
    srepo.create(name: "Stu", email: "s@x", active: true)
    crepo.create(code: "C1", title: "Course")
  end
  it "prevents duplicate enrollment (historical bug)" do
    svc.enroll(student_id: 1, course_id: 1)
    expect { svc.enroll(student_id: 1, course_id: 1) }.to raise_error(Cms::ValidationError, /already enrolled/)
  end
end
