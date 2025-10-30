# frozen_string_literal: true
require "fileutils"
module Cms
  class BackupService
    def initialize(paths); @paths = Array(paths) end
    def snapshot(dir)
      FileUtils.mkdir_p(dir)
      @paths.each do |p|
        bn = File.basename(p)
        FileUtils.cp(p, File.join(dir, bn))
      end
      Dir.children(dir).sort
    end
  end
end
