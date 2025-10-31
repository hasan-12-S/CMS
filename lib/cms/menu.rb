# frozen_string_literal: true
module Cms
  class Menu
    def initialize(cli); @cli = cli end
    def show
      puts "\n== Student CMS v#{Cms::VERSION} =="
      puts "1) List students"
      puts "2) Add student"
      puts "3) List courses"
      puts "4) Add course"
      puts "5) Enroll student in course"
      puts "6) Reports"
      puts "7) Department Summary Reports"
      puts "8) Register student for a course"
      puts "9) Approve/Reject pending registrations"
      puts "10) Exit"

    end
    def handle(choice)
      case choice
      when "1" then @cli.list_students
      when "2" then @cli.add_student
      when "3" then @cli.list_courses
      when "4" then @cli.add_course
      when "5" then @cli.enroll_student
      when "6" then @cli.reports_menu
      when "7" then @cli.department_reports
      when "8" then @cli.register_student
      when "9" then @cli.manage_registrations
      when "10" then :exit

      else puts "Unknown option"
      end
    end
  end
end
