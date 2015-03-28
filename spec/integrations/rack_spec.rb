require 'spec_helper'

Capybara.app = RackApp

RSpec.describe(HelloReflector, type: :feature) do
  context 'Basic app validation' do
    it 'functions as a basic app' do
      visit '/'
      expect(page).to have_content('Hello World!')
    end
  end

  context 'Confirm session manipulation' do
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
end
