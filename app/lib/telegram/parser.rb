
module Telegram

  class Parser

    attr_accessor :message, :chat_id

    def initialize params
      @message = params[:message][:text]
      @chat_id = params[:message][:chat][:id]
    end

  end

end
