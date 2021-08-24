
class TelegramsController < ApplicationController

  def create
    Telegram::ProcessorJob.perform_later params.permit([:update_id, message: {}, telegram: {}])
    render inline: '', status: 201
  end

end
