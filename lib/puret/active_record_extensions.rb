module Puret
  module ActiveRecordExtensions
    module ClassMethods
      # Configure translation model dependency.
      # Eg:
      #   class PostTranslation < ActiveRecord::Base
      #     puret_for :post
      #   end
      def puret_for(model)
        belongs_to model
        validates_presence_of model, :locale
        validates_uniqueness_of :locale, :scope => "#{model}_id"
      end

      # Configure translated attributes.
      # Eg:
      #   class Post < ActiveRecord::Base
      #     puret :title, description
      #   end
      def puret(*attributes)
        make_it_puret! unless included_modules.include?(InstanceMethods)

        attributes.each do |attribute|
          define_method "#{attribute}=" do |value|
            puret_attributes[attribute] = value
          end

          define_method attribute do
            return puret_attributes[attribute] if puret_attributes[attribute]
            return if new_record?

            translation = translations.detect { |t| t.locale.to_sym == I18n.locale } ||
              translations.detect { |t| t.locale.to_sym == I18n.default_locale } ||
              translations.first

            translation ? translation[attribute] : nil
          end
        end
      end

      private

      def make_it_puret!
        include InstanceMethods

        has_many :translations, :class_name => "#{self.to_s}Translation", :dependent => :destroy
        after_save :update_translations!
      end
    end

    module InstanceMethods
      def puret_attributes
        @puret_attributes ||= {}
      end

      def update_translations!
        return if puret_attributes.blank?
        translation = translations.find_or_initialize_by_locale(I18n.locale.to_s)
        translation.attributes = translation.attributes.merge(puret_attributes)
        translation.save!
      end
    end
  end
end

ActiveRecord::Base.extend Puret::ActiveRecordExtensions::ClassMethods
