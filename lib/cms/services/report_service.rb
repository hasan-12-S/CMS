# frozen_string_literal: true
module Cms
  class ReportService
    def initialize(student_repo:, course_repo:, enrollment_repo:)
      @students, @courses, @enrollments = student_repo, course_repo, enrollment_repo
    end
    def roster(course_id)
      ens = @enrollments.for_course(course_id)
      ens.map { |e| @students.find(e[:student_id]) }.compact
    end
    def schedule(student_id)
      ens = @enrollments.for_student(student_id)
      ens.map { |e| @courses.find(e[:course_id]) }.compact
    end
    def gpa(student_id)
      enrolls = @enrollments.for_student(student_id)
      return nil if enrolls.empty?
      grade_map = { "A" => 4.0, "B" => 3.0, "C" => 2.0, "D" => 1.0, "F" => 0.0 }
      points = enrolls.map { |e| grade_map[e[:grade].to_s.upcase] }.compact
      return nil if points.empty?
      (points.sum / points.size).round(2)
    end
  end
end
