# frozen_string_literal: true
module Cms
  class IdGenerator
    def initialize(start: 1); @next = start end
    def next_id; id = @next; @next += 1; id end
  end
end
