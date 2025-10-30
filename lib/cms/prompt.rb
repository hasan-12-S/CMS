# frozen_string_literal: true
module Cms
  class Prompt
    def self.ask(label); print("#{label}: "); STDIN.gets.to_s.chomp end
    def self.ask_int(label)
      loop do
        s = ask(label)
        begin; return Integer(s); rescue ArgumentError; puts "Please enter a valid integer."; end
      end
    end
  end
end
