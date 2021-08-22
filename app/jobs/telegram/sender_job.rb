
class Telegram::SenderJob < ActiveJob::Base
  queue_as :default

  def perform params
    sender= Telegram::Sender.new params[:response]
    sender.send
  end
end
