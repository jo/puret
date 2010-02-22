require 'generators/puret'

module Puret
  module Generators
    class ModelGenerator < Base
      desc "Generates a translation model for the given model NAME (or create it if one does not exist) with Puret configuration plus a migration file."

      argument :attributes, :type => :array, :default => [], :banner => "field:type field:type"

      # create model
      def copy_model_template
        template "model.rb", translation_model_path
      end

      # configure puret attributes in model
      def inject_puret_config_into_model
        inject_into_class model_path, class_name, <<-CONTENT
  puret #{attributes.map { |a| ":%s" % a.name }.join(", ")}
    CONTENT
      end

      # create migration
      def copy_migration_template
        migration_template "migration.rb", "db/migrate/create_#{translations_table_name}"
      end
    end
  end
end

