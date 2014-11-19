require 'active_support/hash_with_indifferent_access'
require 'active_model'
require 'params_validator/version'

module ParamsValidator

  autoload :Base,  'params_validator/base'

  module Connectors
    autoload :ParamsFor,  'params_validator/connectors/params_for'
  end
end
