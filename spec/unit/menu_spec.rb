# frozen_string_literal: true

require 'rspec'
require_relative '../../modules/menu'

RSpec.describe 'Menu:' do
  context 'When testing the Menu class' do
    it 'The menu object should be initialized' do
      expect(Menu.new('url').class).to eq Menu

      expect(Menu.new('url').data).to eq []
    end

    it 'The menu tries to scrape, but since there is no url provided it returns a "error"' do
      expect(Menu.new('url').menu).to eq 'Unable to fetch menu'
    end
  end
end
