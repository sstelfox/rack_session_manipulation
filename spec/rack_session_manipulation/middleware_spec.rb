require 'spec_helper'

RSpec.describe(RackSessionManipulation::Middleware) do
  let(:app)             { double }
  let(:default_config)  { RackSessionManipulation::Config.new }

  subject { described_class.new(app) }

  context 'Action Handlers' do
    let(:null_request) { double.as_null_object }

    it 'allows reseting the session state' do
      expect(null_request).to receive(:clear)
      expect(subject.reset(null_request)).to eql([204, subject.headers(0), ''])
    end

    it 'allows retrieving the session state' do
      input_state = { 'more' => 6 }

      expect(null_request).to receive(:to_hash).and_return(input_state)

      status, _, content = subject.retrieve(null_request)

      expect(status).to eq(200)
      expect(default_config.encoder.decode(content)).to eq(input_state)
    end

    it 'allows updating the session state' do
      input_state = default_config.encoder.encode({ 'shivering-winter-passage' => 'betaroma' })
      param_double = double

      expect(param_double).to receive(:[]).with('session_data').and_return(input_state)

      expect(null_request).to receive(:params).and_return(param_double)
      expect(null_request).to receive(:[]=).with('shivering-winter-passage', 'betaroma')

      status, headers, content = subject.update(null_request)

      expect(status).to eq(303)
      expect(headers).to have_key('Location')
      expect(content).to eq('')
    end

    it 'returns a client error when bad data is provided' do
      input_state = 'Not even close to real JSON'
      param_double = double

      expect(param_double).to receive(:[]).with('session_data').and_return(input_state)
      expect(null_request).to receive(:params).and_return(param_double)

      status, _, _ = subject.update(null_request)
      expect(status).to eq(400)
    end
  end

  context 'Middleware Request Handling' do
    it 'sends middleware requests through the safe handler' do
      env = Rack::MockRequest.env_for(default_config.path, method: :get)
      expect(subject).to receive(:safe_handle)

      subject.call(env)
    end

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

    it 'allows exceptions to bubble through it' do
      env = Rack::MockRequest.env_for('/oh_nose')
      expect(app).to receive(:call).with(env).and_raise('Somethings broken!')

      expect { subject.call(env) }.to raise_error('Somethings broken!')
    end
  end

  context 'Request Handling Helpers' do
    context '#extract_method' do
      it 'uses _method parameter when available'
      it 'falls back to the request method if _method parameter is not present'
    end

    context '#get_action' do
      it 'returns nil when path doesn\'t match the configured one'
      it 'returns a symbol action based on the extracted method'
    end

    context '#headers' do
      it 'populates common headers with provided length'
    end

    context '#safe_handle' do
      it 'returns and appropriate response when an error is introduced'
      it 'calls the provided action under normal conditions'
    end
  end
end
