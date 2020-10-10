# frozen_string_literal: true

require 'rspec'
require_relative '../../modules/time'

RSpec.describe 'Time:' do
  context 'When testing the Time class' do
    it 'The time object should be initialized' do
      expect(Time.new.class).to eq Time
      expect(Time.day_of_week).to eq 'Unable to fetch current day'
    end
  end
end
