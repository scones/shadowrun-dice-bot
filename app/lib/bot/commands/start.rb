
class Bot::Commands::Start < Bot::Commands::Abstract

  def self.help_message
    <<~HELP
      /#{self.command_name}
      start the conversation
    HELP
  end

  def execute
    "Ready to roll"
  end

end
