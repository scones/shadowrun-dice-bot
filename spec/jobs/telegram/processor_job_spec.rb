require 'rails_helper'

RSpec.describe Telegram::ProcessorJob, type: :job do
  include ActiveJob::TestHelper

  let(:message) {
    {
    	"update_id": 875960598,
    	"message": {
    		"message_id": 2,
    		"from": {
    			"id": 526779048,
    			"is_bot": false,
    			"first_name": "Sco",
    			"last_name": "Nes",
    			"username": "secretscones",
    			"language_code": "de"
    		},
    		"chat": {
    			"id": 526779048,
    			"first_name": "Sco",
    			"last_name": "Nes",
    			"username": "secretscones",
    			"type": "private"
    		},
    		"date": 1563317118,
    		"text": "Foo"
    	},
    	"telegram": {
    		"update_id": 875960598,
    		"message": {
    			"message_id": 2,
    			"from": {
    				"id": 526779048,
    				"is_bot": false,
    				"first_name": "Sco",
    				"last_name": "Nes",
    				"username": "secretscones",
    				"language_code": "de"
    			},
    			"chat": {
    				"id": 526779048,
    				"first_name": "Sco",
    				"last_name": "Nes",
    				"username": "secretscones",
    				"type": "private"
    			},
    			"date": 1563317118,
    			"text": "Foo"
    		}
    	}
    }
  }

  subject(:job) { described_class.perform_later(message) }

  describe '#perform' do

    let (:response ) { Telegram::Response }

    it 'creates a telegram response from the bot' do
      expect_any_instance_of(Bot::Parser).to receive(:response).and_return('foo')
      expect(Telegram::SenderJob).to receive(:perform_later).with({text: 'foo', chat_id: 526779048})

      perform_enqueued_jobs { job }
    end

  end

end
