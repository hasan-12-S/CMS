# frozen_string_literal: true
module Cms
  class DepartmentRepo < BaseRepo
    def find_by_name(name)
      all.find { |d| d[:name].casecmp?(name) }
    end
  end
end
