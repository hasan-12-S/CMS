# frozen_string_literal: true
module Cms
  class EnrollmentService
    def initialize(repo, student_repo:, course_repo:, logger: Logger.new)
      @repo, @student_repo, @course_repo, @logger = repo, student_repo, course_repo, logger
    end
    def enroll(student_id:, course_id:)
      raise ValidationError, "student missing" unless @student_repo.find(student_id)
      raise ValidationError, "course missing"  unless @course_repo.find(course_id)
      # Historical bug (fixed): duplicate enrollment wasn't prevented.
      raise ValidationError, "already enrolled" if @repo.exists?(student_id: student_id, course_id: course_id)
      rec = @repo.create(student_id: student_id, course_id: course_id, grade: nil)
      @logger.info("enrollment ##{rec[:id]} S#{student_id}->C#{course_id}"); rec
    end
    def list_for_student(student_id); @repo.for_student(student_id) end
  end
end
