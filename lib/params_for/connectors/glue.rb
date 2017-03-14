require 'active_support/concern'

module ParamsFor
  module Connectors
    module Glue
      extend ActiveSupport::Concern

      module ClassMethods
        # Define params for and before_action all in the same method
        #
        # @param name [Symbol] camelcased validator class name
        # @param options [Hash] optional
        # @option options [Boolean] :class class of the validator
        # @option options [Array] any option that before_action takes
        def params_for(name, options = {})
          method_name = "#{name}_params"
          define_method(method_name) do
            return params_for(name, options)
          end
          return if options[:before_action] == false
          send(:before_action, method_name.to_sym, options)
        end
      end

      private

      # Strong params checker
      #
      # @param name [Symbol] camelcased validator class name
      # @param options [Hash] optional
      # @option options [Boolean] :class class of the validator
      # @return [Hash]
      def params_for(name, options = {})
        instance_var_name = "@#{name.to_s}_params"
        instance_var = instance_variable_get(instance_var_name)
        return instance_var if instance_var.present?

        validator_klass = options[:class].presence || "ParamsFor::#{name.to_s.classify}".constantize

        validator = validator_klass.new(params)

        unless validator.valid?
          render status: :bad_request, json: validator.errors.to_json and return false
        end

        instance_variable_set(instance_var_name, validator.to_params)
      end
    end
  end
end
