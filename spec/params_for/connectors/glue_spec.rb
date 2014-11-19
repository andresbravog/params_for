require 'json'
require 'spec_helper'

describe DummyController, type: :controller do

  describe '.params_for' do
    it 'defines a before_action with given attributes'
    it 'defines a instance method to retrieve the params'
    it 'uses the class option if given'
  end

  describe '.index' do
    let(:valid_params) { { id: 123, name: 'new_name' } }
    let(:response_data) { JSON.parse(subject.body) }
    before { get :index, valid_params }
    subject { response }

    it { should be_success }
    it { expect(response_data).to include('id') }
    it { expect(response_data['id']).to eql('123') }
    it { expect(response_data).to include('name') }
    it { expect(response_data['name']).to eql('new_name') }

    context 'whithout id param' do
      let(:valid_params) { { id: nil, name: 'new_name' } }

      it { expect(subject.status).to eql(400) }
      it { expect(response_data['id']).to include('can\'t be blank') }
    end
    context 'with a different param' do
      let(:valid_params) { { id: 123, other_param: 'new_value' } }

      it { should be_success }
      it { expect(response_data).to_not include('other_param') }
    end
  end
end
