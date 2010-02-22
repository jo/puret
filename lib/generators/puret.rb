require 'rails/generators/named_base'
require 'rails/generators/active_model'
require 'rails/generators/migration'

module Puret
  module Generators
    class Base < Rails::Generators::NamedBase #:nodoc:
      include Rails::Generators::Migration

      def self.source_root
        @_puret_source_root ||= begin
          if base_name && generator_name
            File.expand_path(File.join(base_name, generator_name, 'templates'), File.dirname(__FILE__))
          end
        end
      end

      def self.next_migration_number(path)
        Time.now.utc.strftime("%Y%m%d%H%M%S")
      end

      # create model unless exists
      def invoke_model
        invoke "model", [name] unless File.exists?(File.join(destination_root, model_path))
      end

      protected
  
      # eg app/models/post.rb
      def model_path
        @model_path ||= File.join("app", "models", "#{file_path}.rb")
      end

      # eg PostTranslation
      def translation_model_class_name
        @translation_model_class_name ||= "#{class_name}Translation"
      end

      # eg app/models/post_translations.rb
      def translation_model_path
        @translation_model_path ||= File.join("app", "models", "#{file_path}_translation.rb")
      end

      def translation_model_exists?
        File.exists?(File.join(destination_root, translation_model_path))
      end

      # eg post_translations
      def translations_table_name
        translation_model_class_name.tableize
      end

      def reference_name
        name.underscore
      end

      def reference_id
        "#{reference_name}_id"
      end
    end
  end
end

