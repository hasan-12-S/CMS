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
  end
end
