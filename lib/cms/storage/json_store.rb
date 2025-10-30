# frozen_string_literal: true
require "json"
require "fileutils"
module Cms
  class JsonStore
    attr_reader :path
    def initialize(path)
      @path = path
      FileUtils.mkdir_p(File.dirname(path))
      File.write(path, JSON.pretty_generate({ "items" => [] })) unless File.exist?(path)
    end
    def read_all
      json = JSON.parse(File.read(@path)); json["items"] || []
    rescue JSON::ParserError
      []
    end
    def write_all(items)
      File.write(@path, JSON.pretty_generate({ "items" => items }))
    end
  end
end
