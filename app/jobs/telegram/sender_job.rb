
class Telegram::SenderJob < ActiveJob::Base
  queue_as :default

  def perform params
    Telegram::Sender.new(params).send
  end
end
