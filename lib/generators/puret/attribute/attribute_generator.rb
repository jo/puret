require 'generators/puret'

module Puret
  module Generators
    class AttributeGenerator < Base
      desc "Generates a translation attribute for the given model NAME (or create it if one does not exist) with Puret configuration plus a migration file."

      argument :attributes, :type => :array, :banner => "field:type field:type"

      # configure puret attributes in model
      def inject_puret_config_into_model
        inject_into_class model_path, class_name, <<-CONTENT
  puret #{attributes.map { |a| ":%s" % a.name }.join(", ")}
    CONTENT
      end

      # create migration
      def copy_attribute_migration_template
        migration_template "migration.rb", "db/migrate/add_#{translations_table_name}"
      end
    end
  end
end

