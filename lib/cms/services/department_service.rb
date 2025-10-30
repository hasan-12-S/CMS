# frozen_string_literal: true
module Cms
  class DepartmentService
    def initialize(repo, student_repo:, course_repo:, logger: Logger.new)
      @repo, @student_repo, @course_repo, @logger = repo, student_repo, course_repo, logger
    end

    def create(name:, head: nil)
      raise ValidationError, "department exists" if @repo.find_by_name(name)
      rec = @repo.create(name: name.strip, head: head)
      @logger.info("department created ##{rec[:id]}: #{rec[:name]}")
      rec
    end

    def list
      @repo.all
    end

    def assign_course(dept_id, course_id)
      course = @course_repo.find(course_id)
      raise ValidationError, "course missing" unless course
      @course_repo.update(course_id, department_id: dept_id)
    end

    def assign_student(dept_id, student_id)
      student = @student_repo.find(student_id)
      raise ValidationError, "student missing" unless student
      depts = Array(student[:departments])
      unless depts.include?(dept_id)
        depts << dept_id
        @student_repo.update(student_id, departments: depts)
      end
    end

    def summary(dept_id)
      dept = @repo.find(dept_id)
      raise ValidationError, "department missing" unless dept
      courses = @course_repo.all.select { |c| c[:department_id] == dept_id }
      students = @student_repo.all.select { |s| Array(s[:departments]).include?(dept_id) }
      {
        name: dept[:name],
        head: dept[:head],
        course_count: courses.size,
        student_count: students.size
      }
    end
  end
end
