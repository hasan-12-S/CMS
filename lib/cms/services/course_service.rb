# frozen_string_literal: true
module Cms
  class CourseService
    def initialize(repo, logger: Logger.new); @repo, @logger = repo, logger end
    def add(code:, title:, credits: 3)
      CourseValidator.validate!(code: code, title: title)
      raise ValidationError, "course code exists" if @repo.find_by_code(code)
      rec = @repo.create(code: code.strip, title: title.strip, credits: credits)
      @logger.info("course created ##{rec[:id]}: #{rec[:code]}"); rec
    end
    def list; @repo.all end
  end
end
