# frozen_string_literal: true
module Cms
  class StudentRepo < BaseRepo
    def find_by_email(email); all.find { |s| s[:email].casecmp?(email) } end
    def active; all.select { |s| s[:active] } end
  end
end
