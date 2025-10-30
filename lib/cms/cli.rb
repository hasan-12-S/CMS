# frozen_string_literal: true
module Cms
  class CLI
    def self.start; new.run end
    def initialize
      @logger = Logger.new
      cfg = Config.new
      student_store = JsonStore.new(cfg.students_path)
      course_store  = JsonStore.new(cfg.courses_path)
      enroll_store  = JsonStore.new(cfg.enrollments_path)
      @student_repo = StudentRepo.new(student_store)
      @course_repo  = CourseRepo.new(course_store)
      @enroll_repo  = EnrollmentRepo.new(enroll_store)
      @students = StudentService.new(@student_repo, logger: @logger)
      @courses  = CourseService.new(@course_repo, logger: @logger)
      @enrolls  = EnrollmentService.new(@enroll_repo, student_repo: @student_repo, course_repo: @course_repo, logger: @logger)
      @reports  = ReportService.new(student_repo: @student_repo, course_repo: @course_repo, enrollment_repo: @enroll_repo)
      @menu = Menu.new(self)
    end
    def run
      loop do
        @menu.show
        choice = Prompt.ask("Choose")
        break if @menu.handle(choice) == :exit
      end
    end
    # Commands
    def list_students
      t = Table.new(%w[id name email active])
      @students.list_active.each { |s| t.add_row([s[:id], s[:name], s[:email], s[:active]]) }
      puts t.render
    end
    def add_student
      name = Prompt.ask("Name"); email = Prompt.ask("Email")
      rec = @students.register(name: name, email: email)
      puts "Created student ##{rec[:id]}"
    rescue ValidationError => e; puts "Error: #{e.message} (#{e.details})"
    end
    def list_courses
      t = Table.new(%w[id code title credits])
      @courses.list.each { |c| t.add_row([c[:id], c[:code], c[:title], c[:credits]]) }
      puts t.render
    end
    def add_course
      code = Prompt.ask("Code"); title = Prompt.ask("Title"); credits = Prompt.ask_int("Credits")
      rec = @courses.add(code: code, title: title, credits: credits); puts "Created course ##{rec[:id]}"
    rescue ValidationError => e; puts "Error: #{e.message} (#{e.details})"
    end
    def enroll_student
      sid = Prompt.ask_int("Student id"); cid = Prompt.ask_int("Course id")
      rec = @enrolls.enroll(student_id: sid, course_id: cid); puts "Enrolled ##{rec[:id]}"
    rescue ValidationError => e; puts "Error: #{e.message}"
    end
    def reports_menu
      puts "Reports:"
      puts "1) Course roster"; puts "2) Student schedule"
      case Prompt.ask("Choose")
      when "1"
        cid = Prompt.ask_int("Course id")
        list = @reports.roster(cid)
        t = Table.new(%w[id name email])
        list.each { |s| t.add_row([s[:id], s[:name], s[:email]]) }
        puts t.render
      when "2"
        sid = Prompt.ask_int("Student id")
        list = @reports.schedule(sid)
        t = Table.new(%w[id code title credits])
        list.each { |c| t.add_row([c[:id], c[:code], c[:title], c[:credits]]) }
        puts t.render
      else
        puts "Unknown report"
      end
    end
  end
end
