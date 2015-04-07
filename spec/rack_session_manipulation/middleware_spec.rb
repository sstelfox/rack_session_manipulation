require 'spec_helper'

RSpec.describe(RackSessionManipulation::Middleware) do
  let(:app)             { double }
  let(:default_config)  { RackSessionManipulation::Config.new }

  subject { described_class.new(app) }

  context 'Original application' do
    it 'falls back to the normal app when path doesn\'t match' do
      env = Rack::MockRequest.env_for('/users/1')
      expect(app).to receive(:call).with(env)

      subject.call(env)
    end

    it 'falls back to the normal app when method doesn\'t match' do
      env = Rack::MockRequest.env_for(default_config.path, method: :post)
      expect(app).to receive(:call).with(env)

      subject.call(env)
    end
  end

  context 'RSM Middleware' do
    it 'calls the reset method on a DELETE request' do
      env = Rack::MockRequest.env_for(default_config.path, method: :delete)
      expect(subject).to receive(:reset)

      subject.call(env)
    end

    it 'calls the retrieve method on a GET request' do
      env = Rack::MockRequest.env_for(default_config.path, method: :get)
      expect(subject).to receive(:retrieve)

      subject.call(env)
    end

    it 'calls the update method on a PUT request' do
      env = Rack::MockRequest.env_for(default_config.path, method: :put)
      expect(subject).to receive(:update)

      subject.call(env)
    end
  end
end
