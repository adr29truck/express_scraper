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
			"type": "section",
			"text": {
				"type": "plain_text",
				"text": "Idag Unable to fetch current day\nExpress: Pasta Pizza\nExpress2: Soup"
			}
		}
        ],
                         channel: '#lunch-menu' }
      error_return_message = { blocks:  [
		{
			"type": "image",
			"image_url": "https://www.reactiongifs.com/r/whapc.gif",
			"alt_text": "Something is broken"
		},
		{
			"type": "section",
			"text": {
				"type": "mrkdwn",
				"text": "Something went wrong."
			},
			"accessory": {
				"type": "button",
				"text": {
					"type": "plain_text",
					"text": "Create issue on GitHub",
					"emoji": true
				},
				"value": "click_me_123",
				"url": "https://github.com/adr29truck/express_scraper",
				"action_id": "button-action"
			}
		}
	]
      }

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
