require 'spec_helper'

Capybara.app = RackApp

# These tests are heavily dependant on the implementation of the HelloReflector
# rack application which can be found in spec/apps/rack_app.rb. This suite of
# tests is intended to confirm the target functionality works from within an
# integrated application.
RSpec.describe(HelloReflector, type: :feature) do
  context 'Minimal application function', type: :rack do
    let(:app) { described_class }

    it 'functions as a basic app' do
      get('/', {}, 'rack.session' => {})
      expect(last_response.body).to have_content('Hello World!')
    end

    it 'returns the content inside of sessions' do
      get('/some_place', {}, 'rack.session' => { 'return' => 'other content' })
      expect(last_response.body).to have_content('other content')
    end
  end

  context 'Capybara tests', type: :feature do
    it 'can access session variables set by the app' do
      visit '/sample'
      expect(page.session['reflection']).to eq('/sample')
    end

    it 'can modify session variables set by tests' do
      page.session = { 'return' => 'other content' }
      visit '/some_place'
      expect(page).to have_content('other content')
    end

    it 'can completely reset a session' do
      visit '/location'
      expect(page.session['reflection']).to eq('/location')

      page.session_reset

      expect(page.session['reflection']).to eq(nil)
    end
  end
end
