
class Telegram::ProcessorJob < ActiveJob::Base
  queue_as :default

  def perform params
    telegram = Telegram::Parser.new params
    bot = Bot::Parser.new telegram.message

    Telegram::SenderJob.perform_later text: bot.response, chat_id: telegram.chat_id
  end

end
