require 'spec_helper'

RSpec.describe(RackSessionManipulation::Capybara) do
  it 'is included in Capybara::Session' do
    expect(Capybara::Session.ancestors.include?(subject))
  end
end
