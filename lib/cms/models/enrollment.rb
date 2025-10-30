# frozen_string_literal: true
module Cms
  class Enrollment
    attr_accessor :id, :student_id, :course_id, :grade
    def initialize(id:, student_id:, course_id:, grade: nil) @id, @student_id, @course_id, @grade = id, student_id, course_id, grade end
    def to_h; { id: @id, student_id: @student_id, course_id: @course_id, grade: @grade } end
    def self.from_h(h); new(id: h["id"], student_id: h["student_id"], course_id: h["course_id"], grade: h["grade"]) end
  end
end
