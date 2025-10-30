# frozen_string_literal: true
module Cms
  class ValidationError < StandardError
    attr_reader :details
    def initialize(message, details = {}); @details = details; super(message) end
  end
end
