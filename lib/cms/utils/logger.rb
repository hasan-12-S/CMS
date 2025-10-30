# frozen_string_literal: true
module Cms
  class Logger
    LEVELS = %i[debug info warn error fatal].freeze
    def initialize(io=$stdout, level: :info) @io, @level = io, level end
    def level=(val) raise ArgumentError, "unknown level" unless LEVELS.include?(val); @level = val end
    LEVELS.each_with_index do |name, idx|
      define_method(name) { |msg| log(idx, name, msg) }
    end
    private
    def current_level_index; LEVELS.index(@level) || 1 end
    def log(idx, name, msg)
      return if idx < current_level_index
      t = Time.now.utc.strftime("%Y-%m-%d %H:%M:%S UTC")
      @io.puts("[#{t}] #{name.upcase}: #{msg}")
    end
  end
end
