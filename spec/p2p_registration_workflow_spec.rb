require_relative "spec_helper"

RSpec.describe "Course Registration Workflow", :p2p do
  let(:srepo) { Cms::StudentRepo.new(tmp_store("students.json")) }
  let(:crepo) { Cms::CourseRepo.new(tmp_store("courses.json")) }
  let(:erepo) { Cms::EnrollmentRepo.new(tmp_store("enrollments.json")) }
  let(:svc)   { Cms::EnrollmentService.new(erepo, student_repo: srepo, course_repo: crepo) }

  before do
    srepo.create(name: "Ali", email: "a@x", active: true)
    crepo.create(code: "CS101", title: "Intro CS", instructor: "Dr. A")
  end

  it "registers student for a course with pending status" do
    e = svc.register(1, 1)
    expect(e[:status]).to eq("pending")
  end

  it "approves a pending registration" do
    e = svc.register(1, 1)
    svc.approve(e[:id])
    expect(erepo.find(e[:id])[:status]).to eq("approved")
  end

  it "rejects a pending registration" do
    e = svc.register(1, 1)
    svc.reject(e[:id])
    expect(erepo.find(e[:id])[:status]).to eq("rejected")
  end

  it "lists pending registrations for an instructor" do
    e = svc.register(1, 1)
    pend = svc.pending_for_instructor(crepo, "Dr. A")
    expect(pend.map { |p| p[:id] }).to include(e[:id])
  end

  it "prevents duplicate registration for same student/course" do
    svc.register(1, 1)
    expect { svc.register(1, 1) }.to raise_error(Cms::ValidationError)
  end

  it "raises error when approving non-existing registration" do
    expect { svc.approve(999) }.to raise_error(Cms::ValidationError)
  end

  it "prevents grading unapproved registration" do
    e = svc.register(1, 1)
    expect { svc.grade(e[:id], "A") }.to raise_error(Cms::ValidationError)
  end

  it "allows grading after approval" do
    e = svc.register(1, 1)
    svc.approve(e[:id])
    svc.grade(e[:id], "A")
    expect(erepo.find(e[:id])[:grade]).to eq("A")
  end
end
