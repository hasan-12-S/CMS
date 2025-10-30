# frozen_string_literal: true
module Cms
  class Department
    attr_accessor :id, :name, :head
    def initialize(id:, name:, head: nil)
      @id, @name, @head = id, name, head
    end
    def to_h
      { id: @id, name: @name, head: @head }
    end
    def self.from_h(h)
      new(id: h["id"], name: h["name"], head: h["head"])
    end
  end
end
