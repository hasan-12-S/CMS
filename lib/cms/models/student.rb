# frozen_string_literal: true
module Cms
  class Student
    attr_accessor :id, :name, :email, :active
    def initialize(id:, name:, email:, active: true) @id, @name, @email, @active = id, name, email, active end
    def to_h; { id: @id, name: @name, email: @email, active: @active } end
    def self.from_h(h); new(id: h["id"], name: h["name"], email: h["email"], active: h.fetch("active", true)) end
  end
end
