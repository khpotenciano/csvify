module Csvify
  class Base
    def self.format_cell(value)
      cell = ""
      value = format_value(value)
      cell = "\"#{value}\","
    end

    def self.format_value(value)
      return_value = ""
      case value.class.to_s
      when "TrueClass", "FalseClass"
        return_value = value ? "Yes" : "No"
      when "Time"
        return_value = value.to_time.strftime("%I:%M %p")
      when "Date"
        return_value = value.to_time.strftime("%m/%d/%Y")
      when "DateTime", "ActiveSupport::TimeWithZone"
        return_value = value.to_time.strftime("%m/%d/%Y %I:%M %p")
      when "Array"
        value.each_with_index do |row, index|
          return_value <<  index == value.size - 1 ? "#{row.to_s}" : "#{row.to_s}"
        end
      else
        return_value = value.to_s
      end
      return_value.gsub! "\"", "\"\""
      return_value
    end
  end
end
