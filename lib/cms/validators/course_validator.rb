# frozen_string_literal: true
module Cms
  class CourseValidator
    def self.validate!(attrs)
      errs = {}
      code = attrs[:code].to_s.strip
      errs[:code] = "must be present" if code.empty?
      title = attrs[:title].to_s.strip
      errs[:title] = "must be present" if title.empty?
      raise ValidationError.new("invalid course", errs) unless errs.empty?
      true
    end
  end
end
