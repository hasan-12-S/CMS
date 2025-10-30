# frozen_string_literal: true
module Cms
  class Course
    attr_accessor :id, :code, :title, :credits
    def initialize(id:, code:, title:, credits: 3) @id, @code, @title, @credits = id, code, title, credits end
    def to_h; { id: @id, code: @code, title: @title, credits: @credits } end
    def self.from_h(h); new(id: h["id"], code: h["code"], title: h["title"], credits: h.fetch("credits", 3)) end
  end
end
