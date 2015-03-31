require 'spec_helper'

Capybara.app = RackApp

# These tests are heavily dependant on the implementation of the HelloReflector
# rack application which can be found in spec/apps/rack_app.rb. This suite of
# tests is intended to confirm the target functionality works from within an
# integrated application.
RSpec.describe(HelloReflector, type: :feature) do
  # Confirm our test app is able to startup and run to it's minimal amount.
  it 'functions as a basic app' do
    visit '/'
    expect(page).to have_content('Hello World!')
  end

  it 'can access session variables set by the app' do
    visit '/sample'
    expect(page.session['reflection']).to eq('/sample')
  end

  it 'can modify session variables set by tests' do
    page.session = { 'return' => 'other content' }
    visit '/some_place'
    expect(page).to have_content('other content')
  end
end
