load File.dirname(__FILE__) + "/base.rb"
module Csvify
  class ActiveRecord < Base
    def self.from_collection(collection, options={})
      init_content
      @collection = collection
      set_resource_type
      set_excluded_fields(options) unless options.empty?
      set_included_associations(options) unless options.empty?
      set_assoc_fields unless @included_associations.empty?
      set_resource_fields
      build_csv
      @csv
    end
    private
      def self.init_content
        @collection               = []
        @resource_type            = nil
        @resource_headers         = ""
        @associations_headers     = ""
        @body                     = ""
        @csv                      = ""
        @resource_fields          = []
        @included_associations    = []
        @association_fields       = {}
        @excluded_fields          = {}
      end

      def self.set_resource_type
        @resource_type = @collection[0].class
      end

      def self.set_excluded_fields(options)
        @excluded_fields = options[:exclude] || {}
      end

      def self.set_resource_fields
        @resource_fields = @resource_type.attribute_names
        @resource_fields -= @excluded_fields[@resource_type.to_s.downcase.to_sym] || []
      end

      def self.set_included_associations(options)
        @included_assoc = options[:include] || []
      end

      def self.set_assoc_fields
        @included_assoc.each do |assoc|
          @association_fields[assoc.to_sym] = assoc.classify.constantize.attribute_names - @excluded_fields[assoc.to_sym]
        end
      end

      def self.build_csv
        @collection.each do |row|
          @body << get_resource_row_values(row)
          @body << "\n"
        end
        build_resource_headers
        @csv = @resource_headers + @associations_headers + "\n" + @body
      end

      def self.get_resource_row_values(row)
        row_values = ""
        @resource_fields.each do |field|
          value = row.try(field)
          value = format_value(value)
          row_values << format_cell(value)
        end
        row_values
      end

      def self.build_resource_headers
        @resource_fields.each do |field|
          @resource_headers << "\"#{field.humanize.capitalize}\","
        end
      end
  end
end
