require 'net/http'
require 'net/https'

class Telegram::Sender

  def initialize params
    @params = params
    @token = Rails.application.config.telegram_bot_token
  end

  def send
    uri = URI("https://api.telegram.org/bot#{@token}/sendMessage")
    Net::HTTP.post_form(uri, @params)
  end

end
