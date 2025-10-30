require_relative "spec_helper"

RSpec.describe "Department Hierarchy System", :p2p do
  let(:srepo) { Cms::StudentRepo.new(tmp_store("students.json")) }
  let(:crepo) { Cms::CourseRepo.new(tmp_store("courses.json")) }
  let(:drepo) { Cms::DepartmentRepo.new(tmp_store("departments.json")) }
  let(:svc)   { Cms::DepartmentService.new(drepo, student_repo: srepo, course_repo: crepo) }

  before do
    srepo.create(name: "Ali", email: "a@x", active: true)
    srepo.create(name: "Sara", email: "s@x", active: true)
    crepo.create(code: "CS101", title: "Intro CS")
    crepo.create(code: "EE101", title: "Circuits")
  end

  it "creates a department" do
    d = svc.create(name: "Computer Science", head: "Dr. Smith")
    expect(d[:name]).to eq("Computer Science")
  end

  it "assigns a course to a department" do
    dept = svc.create(name: "CS", head: "Dr. A")
    course = crepo.create(code: "C1", title: "Algo")
    svc.assign_course(dept[:id], course[:id])
    expect(crepo.find(course[:id])[:department_id]).to eq(dept[:id])
  end

  it "assigns a student to a department" do
    dept = svc.create(name: "EE", head: "Dr. B")
    student = srepo.create(name: "John", email: "j@x", active: true)
    svc.assign_student(dept[:id], student[:id])
    updated = srepo.find(student[:id])
    expect(updated[:departments]).to include(dept[:id])
  end

  it "returns summary with correct counts" do
    dept = svc.create(name: "IT", head: "Dr. Z")
    course = crepo.create(code: "IT1", title: "Networks", department_id: dept[:id])
    student = srepo.create(name: "Khan", email: "k@x", active: true, departments: [dept[:id]])
    s = svc.summary(dept[:id])
    expect(s[:course_count]).to eq(1)
    expect(s[:student_count]).to eq(1)
  end

  it "handles multiple students across departments" do
    d1 = svc.create(name: "CS", head: "A")
    d2 = svc.create(name: "EE", head: "B")
    s1 = srepo.create(name: "X", email: "x@x", active: true)
    s2 = srepo.create(name: "Y", email: "y@x", active: true)
    svc.assign_student(d1[:id], s1[:id])
    svc.assign_student(d2[:id], s2[:id])
    expect(srepo.find(s1[:id])[:departments]).to eq([d1[:id]])
    expect(srepo.find(s2[:id])[:departments]).to eq([d2[:id]])
  end

  it "prevents duplicate department creation" do
    svc.create(name: "CS", head: "A")
    expect { svc.create(name: "CS", head: "B") }.to raise_error(Cms::ValidationError)
  end

  it "raises error when department missing" do
    expect { svc.summary(999) }.to raise_error(Cms::ValidationError)
  end
end
