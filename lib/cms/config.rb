# frozen_string_literal: true
module Cms
  class Config
    attr_reader :data_dir
    def initialize(data_dir: File.expand_path("../../data", __dir__))
      @data_dir = data_dir
    end
    def students_path; File.join(@data_dir, "students.json") end
    def courses_path; File.join(@data_dir, "courses.json") end
    def enrollments_path; File.join(@data_dir, "enrollments.json") end
  end
end
