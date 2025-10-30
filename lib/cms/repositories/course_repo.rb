# frozen_string_literal: true
module Cms
  class CourseRepo < BaseRepo
    def find_by_code(code); all.find { |c| c[:code].casecmp?(code) } end
  end
end
