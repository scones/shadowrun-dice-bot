
class Bot::Commands::Help < Bot::Commands::Abstract

  def execute
    message = commands.inject([]) do |target, command|
      help = command.help_message
      target << help if help
      target
    end.join("\n\n")
    {message: message, chat_id: @user.telegram_user_id}
  end

  def self.help_message
  end

  def commands
    Bot::Commands.constants.map do |c|
      Bot::Commands.const_get(c)
    end.select do |c|
      c.is_a? Class
    end
  end

end
