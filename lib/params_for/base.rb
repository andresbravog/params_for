# app/validators/param_validator/base.rb

module ParamsFor
  class Base
    include ActiveModel::Validations

    # Memoizes the accessor atrributes in the @attributes variable to be able
    # to list them and access them
    #
    def self.attr_accessor(*vars)
      @attributes ||= []
      @attributes.concat vars
      super(*vars)
    end

    # Accessor method to the memoized attrubutes setted by the attr_accessor method
    #
    # @return [Array(Symbols)]
    def self.attributes
      @attributes ||= []

      super_attributes = superclass.attributes if superclass && superclass.respond_to?(:attributes)
      (super_attributes || []) + @attributes
    end

    # Initializes the param validator object with the given controller params
    # HashwithIndifferentAccess object and feeds any defined attribute with the given param key
    # if they exists
    #
    def initialize(params = {})
      params.each do |key, value|
        attribute?(key) && send("#{key}=", value)
      end
    end

    # Alias for the attributes class method
    #
    # @return [Array(Symbol)]
    def attributes
      self.class.attributes
    end

    # Returns the given attibutes validated and parsed if needed
    # to be used in the controller
    #
    # @return [HashWithIndifferentAccess]
    def to_params
      ::HashWithIndifferentAccess.new(attributes_hash)
    end

    private

    # Whenever the given they is a valid attribute or not
    #
    # @return [Boolean]
    def attribute?(key)
      self.class.attributes.include? key.to_sym
    end

    # Return the attributes of the validator filtered by
    # attributes has been set in the initializer with params
    #
    # @return [Array<Symbol>]
    def settled_attributes
      instance_vars = self.instance_variables.map do |attr|
        attr.to_s[1..-1].to_sym
      end

      instance_vars & attributes
    end

    # Return a hash with the attributes and values that
    # will be sent to the controller
    #
    # @return [Hash] {attribute1: value, attribute2: value}
    def attributes_hash
      settled_attributes.inject({}) do |out, attribute|
        value = public_send(attribute)
        out[attribute] = value
        out
      end
    end
  end
end
