require 'action_controller'
require 'params_validator'
require 'ostruct'

module Rails
  def self.application
    @application ||= begin
      routes = ActionDispatch::Routing::RouteSet.new
      OpenStruct.new(:routes => routes, :env_config => {})
    end
  end

  def self.app
    application
  end
end

module ControllerExampleGroup
  def self.included(base)
    base.extend ClassMethods
    base.send(:include, ActionController::TestCase::Behavior)

    base.prepend_before do
      @routes = Rails.application.routes
      @controller = described_class.new
    end
  end

  module ClassMethods
    def setup(*methods)
      methods.each do |method|
        if method.to_s =~ /^setup_(fixtures|controller_request_and_response)$/
          prepend_before { send method }
        else
          before         { send method }
        end
      end
    end

    def teardown(*methods)
      methods.each { |method| after { send method } }
    end
  end
end

Rails.application.routes.draw do
  resources :dummy, only: [:index]
end

class ParamsValidator::Dummy < ParamsValidator::Base
  attr_accessor :id, :name

  validates :id, presence: true
end


class DummyController < ActionController::Base
  include Rails.application.routes.url_helpers
  include ParamsValidator::Connectors::ParamsFor

  params_for :dummy

  def index
    render status: 200, json: dummy_params.to_json
  end

end
