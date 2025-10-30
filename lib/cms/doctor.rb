# frozen_string_literal: true
module Cms
  class Doctor
    def initialize(student_repo:, course_repo:, enrollment_repo:)
      @students, @courses, @enrollments = student_repo, course_repo, enrollment_repo
    end
    def run
      issues = []
      @enrollments.all.each do |e|
        issues << "missing student #{e[:student_id]}" unless @students.find(e[:student_id])
        issues << "missing course #{e[:course_id]}"   unless @courses.find(e[:course_id])
      end
      issues
    end
  end
end
