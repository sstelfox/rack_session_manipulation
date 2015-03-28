require 'spec_helper'

Capybara.app = RackApp

RSpec.describe('RackApp', type: :feature) do
  context 'Basic app validation' do
    it 'functions as a basic app' do
      visit '/'
      expect(page).to have_content('Hello World!')
    end
  end
end
