# frozen_string_literal: true

module Cms
  class Enrollment
    attr_accessor :id, :student_id, :course_id, :grade, :status

    def initialize(id:, student_id:, course_id:, grade: nil, status: "pending")
      @id = id
      @student_id = student_id
      @course_id = course_id
      @grade = grade
      @status = status
    end

    def to_h
      {
        id: @id,
        student_id: @student_id,
        course_id: @course_id,
        grade: @grade,
        status: @status
      }
    end

    def self.from_h(h)
      new(
        id: h["id"],
        student_id: h["student_id"],
        course_id: h["course_id"],
        grade: h["grade"],
        status: h["status"] || "pending"
      )
    end
  end
end
