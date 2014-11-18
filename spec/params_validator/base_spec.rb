require 'spec_helper'

describe ParamsValidator::Base do

  let(:validator_klass) do
    unless defined?(DummyValidator)
      class DummyValidator < ParamsValidator::Base
        attr_accessor :id, :name, :type

        validates :type, inclusion: { in: %w{task project}, allow_nil: true }
      end
    end
    DummyValidator
  end
  let(:validator) do
    validator_klass.new(id: 'asd', name: 3, new_param: 'ads')
  end

  describe 'attr_accessor' do
    it 'assigns every attribute accessor to a attributes variable' do
      expect(validator_klass.attributes).to eql([:id, :name, :type])
    end
  end
  describe 'initialize' do
    it 'assigns the given param to the attribute if exists' do
      expect(validator.id).to eql('asd')
    end
    it 'not assigns the given param to the attribute if not exists' do
      expect { validator.new_param }.to raise_error
    end
  end
  describe 'to_params' do
    it 'returns a hash with indifferent access' do
      expect(validator.to_params.class).to eql(HashWithIndifferentAccess)
    end
    it 'uses attributes_hash to create the hash' do
      expect(HashWithIndifferentAccess).to receive(:new).with(validator.send(:attributes_hash))

      validator.to_params
    end
  end

  describe 'attributes_hash' do
    let(:validator_klass_with_modified_accessor) do
      unless defined?(NewDummyValidator)
        class NewDummyValidator < ParamsValidator::Base
          attr_accessor :id, :name

          def id
            'foo'
          end
        end
      end
      NewDummyValidator
    end
    let(:validator_with_modified_accessor) do
      validator_klass_with_modified_accessor.new(
        id: 'asd',
        name: 3,
        new_param: 'ads'
      )
    end

    let(:validator_with_only_one_attribute_set) do
      validator_klass_with_modified_accessor.new(
        name: 3,
        param_to_ignore: 'ads'
      )
    end

    it 'is protected' do
      expect { validator.attributes_hash }.to raise_error
    end
    it 'returns a hash' do
      expect(validator.send(:attributes_hash).class).to eql(Hash)
    end
    it 'contains every attribute' do
      [:id, :name].each do |attribute|
        expect(validator.send(:attributes_hash)).to include(attribute)
      end
    end

    it 'contains attributes set to nil if the nil is explicit' do
      validator.id = nil
      expect(validator.send(:attributes_hash)).to include(:id)
    end

    it 'uses accessors to get the attributes' do
      expect(validator_with_modified_accessor.send(:attributes_hash)[:id]).to eql('foo')
    end

    it 'return only the attributes explicitly set' do
      expect(validator_with_only_one_attribute_set.send(:attributes_hash).keys).to eq([:name])
    end

    it 'is valid with no type given' do
      expect(validator).to be_valid
    end
  end
end
