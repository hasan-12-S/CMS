# frozen_string_literal: true
module Cms
  class EnrollmentRepo < BaseRepo
    def for_student(student_id); all.select { |e| e[:student_id] == student_id } end
    def for_course(course_id); all.select { |e| e[:course_id] == course_id } end
    def exists?(student_id:, course_id:); all.any? { |e| e[:student_id] == student_id && e[:course_id] == course_id } end
  end
end
