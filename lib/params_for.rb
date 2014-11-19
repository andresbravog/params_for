require 'active_support/hash_with_indifferent_access'
require 'active_model'
require 'params_for/version'

module ParamsFor

  autoload :Base,  'params_for/base'

  module Connectors
    autoload :Glue,  'params_for/connectors/glue'
  end
end
