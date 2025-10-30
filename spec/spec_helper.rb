# frozen_string_literal: true
require "bundler/setup"
require "rspec"

# Force absolute require of lib/cms.rb no matter where RSpec runs from
require File.expand_path("../lib/cms.rb", __dir__)

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # Handy helper for temp JsonStore paths
  def tmp_store(name)
    dir = File.join(Dir.pwd, "tmp_test")
    Dir.mkdir(dir) unless Dir.exist?(dir)
    path = File.join(dir, name)
    s = Cms::JsonStore.new(path)
    s.write_all([])
    s
  end
end
