require 'spec_helper'

RSpec.describe(RackSessionManipulation::Middleware) do
  let(:app)             { double }
  let(:default_config)  { RackSessionManipulation::Config.new }
  let(:encoder)         { default_config.encoder }

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
      expect(encoder.decode(content)).to eq(input_state)
    end

    it 'allows updating the session state' do
      input_state = encoder.encode('shivering-winter' => 'passage')
      param_double = double

      expect(param_double)
        .to receive(:[]).with('session_data').and_return(input_state)

      expect(null_request).to receive(:params).and_return(param_double)
      expect(null_request).to receive(:[]=).with('shivering-winter', 'passage')

      status, headers, content = subject.update(null_request)

      expect(status).to eq(303)
      expect(headers).to have_key('Location')
      expect(content).to eq('')
    end

    it 'returns a client error when bad data is provided' do
      input_state = 'Not even close to real JSON'
      param_double = double

      expect(param_double)
        .to receive(:[]).with('session_data').and_return(input_state)
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
      it 'uses _method parameter when available' do
        params = { '_method' => 'post' }
        request = double

        expect(request).to_not receive(:request_method)
        expect(request).to receive(:params).and_return(params).twice

        action = subject.extract_method(request)
        expect(action).to eq('POST')
      end

      it 'defaults to the request method if _method parameter is not present' do
        params = {}
        request = double

        expect(request).to receive(:params).and_return(params)
        expect(request).to receive(:request_method).and_return('PUT')

        action = subject.extract_method(request)
        expect(action).to eq('PUT')
      end
    end

    context '#get_action' do
      it 'returns nil when path doesn\'t match the configured one' do
        request = double

        expect(request).to receive(:path).and_return('/not_the_config_path')
        expect(subject).to_not receive(:routes)

        expect(subject.get_action(request)).to eq(nil)
      end

      it 'returns an action when the path matches the configured one' do
        request = double

        expect(request).to receive(:path).and_return(default_config.path)
        expect(subject).to receive(:extract_method).with(request)

        subject.get_action(request)
      end
    end

    context '#headers' do
      it 'populates common headers with provided length' do
        hdrs = subject.headers(178)

        expect(hdrs).to have_key('Content-Length')
        expect(hdrs).to have_key('Content-Type')

        expect(hdrs['Content-Length']).to eq(178)

        # Ensure this test gets updated if we mess around with the headers
        expect(hdrs.keys.length).to eq(2)
      end
    end

    context '#safe_handle' do
      let(:null_request) { double }

      it 'returns a server error when the action doesn\'t exist' do
        expect(subject).to_not respond_to(:broken_action)

        status, _, content = subject.safe_handle(:broken_action, null_request)

        expect(status).to eq(500)
        expect(content).to start_with('undefined method')
      end

      it 'returns a server error when the action raises an error' do
        expect(subject)
          .to receive(:raising_action).with(null_request).and_raise('message')

        status, _, content = subject.safe_handle(:raising_action, null_request)

        expect(status).to eq(500)
        expect(content).to eq('message')
      end

      it 'calls the provided action under normal conditions' do
        expect(subject).to receive(:testing_action).with(null_request)

        subject.safe_handle(:testing_action, null_request)
      end
    end
  end
end
