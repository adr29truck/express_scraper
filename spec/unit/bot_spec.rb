# frozen_string_literal: true

require 'rspec'
require_relative '../../modules/bot'

RSpec.describe 'Bot:' do
  context 'When testing the Bot class' do
    it 'the bot object should be initialized' do
      expect(Bot.new('webhook').class).to eq Bot
      expect(expect_error).to eq NoMethodError
    end

    it 'the bot message parser should parse a valid message' do
      return_message = { blocks: [{
        text: {
          text: "Idag Unable to fetch current day \nExpress: Pasta Pizza\nExpress2: Soup",
          type: 'mrkdwn'
        },
        type: 'section'
      }],
                         channel: '#lunch-menu' }

      expect(Bot.new('webhook').parse_message([{ type: 'Express', dish: 'Pasta Pizza' },
                                               { type: 'Express2', dish: 'Soup' }])).to eq return_message
    end
  end
end

def expect_error
  Bot.new('webhook').webhook_uri
rescue StandardError => e
  e.class
end
