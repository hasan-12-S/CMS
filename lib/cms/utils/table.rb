# frozen_string_literal: true
module Cms
  class Table
    def initialize(headers); @headers, @rows = headers, [] end
    def add_row(row); @rows << row end
    def render
      widths = @headers.map(&:length)
      @rows.each { |r| r.each_with_index { |v,i| widths[i] = [widths[i], v.to_s.length].max } }
      sep = "+-" + widths.map { |w| "-"*w }.join("-+-") + "-+"
      out = []
      out << sep
      out << "| " + @headers.each_with_index.map { |h,i| h.to_s.ljust(widths[i]) }.join(" | ") + " |"
      out << sep
      @rows.each { |r| out << "| " + r.each_with_index.map { |v,i| v.to_s.ljust(widths[i]) }.join(" | ") + " |" }
      out << sep
      out.join("\n")
    end
  end
end
