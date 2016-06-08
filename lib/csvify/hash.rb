module Csvify
  class Hash
    def self.from_collection(collection, options)
      init_content
      @collection = collection
      build_parent_resource_headers
      build_csv
    end

    private
      def self.init_content
        @collection                   = []
        @parent_resource_name         = ""
        @parent_resource_headers      = ""
        @child_resource_headers       = ""
        @body                         = ""
        @csv                          = ""
        @parent_resource_keys         = []
        @child_resources              = []
        @child_resource_keys          = {}
        @exclude_parent_keys          = []
        @exclude_child_keys           = {}
      end

      def self.is_atomic object
        atomic_types = ["String", "Numeric", "TrueClass", "FalseClass", "Date", "DateTime", "ActiveSupport::TimeWithZone", "Time", "Array"]
        atomic_types.include? object.class.to_s
      end

      def self.classify_parent_resource_keys(row)
        row.keys.each do |key|
          if is_atomic(row)
            @parent_resource_keys << key if !@parent_resource_keys.include? key
          else
            if !@child_resources.include? key
              @child_resources << key
              @child_resource_keys[key] = []
            end
          end
        end
      end

      def self.build_csv
        @collection.each_with_index do |row, index|
          classify_parent_resource_keys row
          @body << get_parent_row_values(row)
          @body << get_child_resources(row)
          @body << "\n"
        end
      end

      def self.get_parent_row_values(row)
        row_values = ""
        @parent_resource_keys.each do |key|
          value = row[key]
          value = format_value(value)
          row_values << format_cell(value)
        end
        row_values
      end

      def self.get_child_resources(row)
        child_rows = ""
        @child_resources.each do |child|
          if !row[child].blank?
            child_rows << blank_row(child)
          else
            child_rows << get_child_resource_row_values(row, child)
          end
        end
        child_rows
      end

      def self.blank_row(resource)
        row = ""
        @child_resource_keys[resource].each do |key|
          row << "\"\","
        end
        row
      end

      def self.get_child_resource_row_values(row, resource)
        row_values = ""
        @child_resource_keys[resource] = @child_resource_keys[resource] | row[resource].keys
        @child_resource_keys[resource].each do |key|
          value = row[resource][key]
          value = format_value(value)
          row_values << format_cell(value)
        end
        row_values
      end

      def self.format_cell(value)
        cell = ""
        value = format_value(value)
        cell = "\"#{value}\","
      end

      def self.format_value(value)
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
          return_value = ""
          value.each_with_index |row, index|
            return_value <<  index == value.size - 1 ? "#{row.to_s}" : "#{row.to_s}"
          end
        else
          return_value = value.to_s
        end
        value = value.gsub! "\"", "\"\""
      end
  end
end
