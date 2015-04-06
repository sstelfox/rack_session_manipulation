require 'spec_helper'

RSpec.describe(RackSessionManipulation::Middleware) do
  let(:app)             { double }
  let(:default_config)  { RackSessionManipulation::Config.new }

  let(:app_env) do
    {
      'PATH_INFO' => '/users/1',
      'REQUEST_METHOD' => 'GET'
    }
  end

  let(:app_env2) do
    {
      'PATH_INFO' => default_config.path,
      'REQUEST_METHOD' => 'POST',
      'rack.input' => StringIO.new('')
    }
  end

  let(:rsm_env) do
    {
      'PATH_INFO' => default_config.path,
      'REQUEST_METHOD' => 'GET'
    }
  end

  subject { described_class.new(app) }

  it 'falls back to the normal app when path doesn\'t match' do
    expect(app).to receive(:call).with(app_env)
    subject.call(app_env)
  end

  it 'falls back to the normal app when method doesn\'t match' do
    expect(app).to receive(:call).with(app_env2)
    subject.call(app_env2)
  end
end
