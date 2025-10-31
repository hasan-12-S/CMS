# frozen_string_literal: true

module Cms
  class EnrollmentService
    def initialize(repo, student_repo:, course_repo:, logger: Logger.new)
      @repo = repo
      @student_repo = student_repo
      @course_repo = course_repo
      @logger = logger
    end

    # === Existing Enrollment (Legacy Direct Enroll) ===
    def enroll(student_id:, course_id:)
      raise ValidationError, "student missing" unless @student_repo.find(student_id)
      raise ValidationError, "course missing" unless @course_repo.find(course_id)
      raise ValidationError, "already enrolled" if @repo.exists?(student_id: student_id, course_id: course_id)

      rec = @repo.create(student_id: student_id, course_id: course_id, grade: nil, status: "approved")
      @logger.info("enrollment ##{rec[:id]} S#{student_id}->C#{course_id}")
      rec
    end

    # === New Registration Workflow ===
    def register(student_id, course_id)
      existing = @repo.all.find { |e| e[:student_id] == student_id && e[:course_id] == course_id }
      raise ValidationError, "already registered" if existing

      rec = @repo.create(student_id: student_id, course_id: course_id, status: "pending", grade: nil)
      @logger.info("registration pending ##{rec[:id]} (S#{student_id}->C#{course_id})")
      rec
    end

    def approve(enrollment_id)
      update_status(enrollment_id, "approved")
    end

    def reject(enrollment_id)
      update_status(enrollment_id, "rejected")
    end

    def update_status(enrollment_id, new_status)
      rec = @repo.find(enrollment_id)
      raise ValidationError, "enrollment not found" unless rec

      @repo.update(enrollment_id, status: new_status)
      @logger.info("enrollment ##{enrollment_id} marked #{new_status}")
    end

    def pending_for_instructor(course_repo, instructor_name)
      courses = course_repo.all.select { |c| c[:instructor] == instructor_name }
      course_ids = courses.map { |c| c[:id] }
      @repo.all.select { |e| e[:status] == "pending" && course_ids.include?(e[:course_id]) }
    end

    def list_for_student(student_id)
      @repo.for_student(student_id)
    end

    # === Optional: Grade setting logic safeguard ===
    def assign_grade(enrollment_id, grade)
      rec = @repo.find(enrollment_id)
      raise ValidationError, "enrollment not found" unless rec
      raise ValidationError, "not approved" unless rec[:status] == "approved"

      @repo.update(enrollment_id, grade: grade)
      @logger.info("grade assigned for enrollment ##{enrollment_id}: #{grade}")
    end
    def grade(enrollment_id, grade)
      rec = @repo.find(enrollment_id)
      raise ValidationError, "enrollment not found" unless rec
      raise ValidationError, "not approved" unless rec[:status] == "approved"

      @repo.update(enrollment_id, grade: grade)
      @logger.info("grade assigned for enrollment ##{rec[:id]}: #{grade}")
      rec
    end

  end
end
