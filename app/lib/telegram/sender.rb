require 'net/http'
require 'net/https'

module Telegram
  class Telegram::Sender

    def initialize response
      @response = response
      @token = Rails.application.config.telegram_token
    end

    def send
      uri = URI("https://api.telegram.org/bot#{@token}/sendMessage")
      Net::HTTP.post_form(uri, response.params)
    end

  end
end
