# frozen_string_literal: true
module Cms
  class StudentValidator
    def self.validate!(attrs)
      errs = {}
      name = attrs[:name].to_s.strip
      errs[:name] = "must be present" if name.empty?
      email = attrs[:email].to_s.strip
      if email.empty?
        errs[:email] = "must be present"
      elsif email !~ /\A[^@\s]+@[^@\s]+\.[^@\s]+\z/
        errs[:email] = "must look like an email"
      end
      raise ValidationError.new("invalid student", errs) unless errs.empty?
      true
    end
  end
end
