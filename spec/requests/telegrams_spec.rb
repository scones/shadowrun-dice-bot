require 'rails_helper'

RSpec.describe TelegramsController, type: :request do

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

  it 'responds with ok' do
    ActiveJob::Base.queue_adapter = :test
    expect{
      post telegram_path, params: message.to_json, headers: { "CONTENT_TYPE" => 'application/json' }
    }
      .to have_enqueued_job
      .with(message.slice(:update_id, :message, :telegram))
  end

end
