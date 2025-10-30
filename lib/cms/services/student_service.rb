# frozen_string_literal: true
module Cms
  class StudentService
    def initialize(repo, logger: Logger.new); @repo, @logger = repo, logger end
    def register(name:, email:)
      StudentValidator.validate!(name: name, email: email)
      raise ValidationError, "email already exists" if @repo.find_by_email(email)
      rec = @repo.create(name: name.strip, email: email.strip, active: true)
      @logger.info("student created ##{rec[:id]}: #{rec[:name]}"); rec
    end
    def deactivate(id)
      rec = @repo.update(id, active: false); raise ValidationError, "student not found" unless rec
      @logger.warn("student deactivated ##{id}"); rec
    end
    def list_active; @repo.active end
  end
end
