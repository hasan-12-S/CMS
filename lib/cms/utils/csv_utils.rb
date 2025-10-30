# frozen_string_literal: true
module Cms
  module CsvUtils
    module_function
    # naive CSV: split by commas, handle quotes minimally
    def parse(line)
      fields, cur, in_q = [], "", false
      line.each_char do |ch|
        if ch == '"'
          in_q = !in_q
        elsif ch == ',' && !in_q
          fields << cur
          cur = ""
        else
          cur << ch
        end
      end
      fields << cur
      fields.map { |s| s.strip.gsub(/^"|"$/,'') }
    end
  end
end
