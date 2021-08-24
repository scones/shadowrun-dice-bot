
class Bot::Commands::Help < Bot::Commands::Abstract

  def execute
    commands.map(&:help_message).join("\n\n")
  end

  def self.help_message
    "/#{self.command_name} print this"
  end

  def commands
    command_classes = Bot::Commands.constants - [:Abstract]
    command_classes.map do |c|
      Bot::Commands.const_get(c)
    end.select do |c|
      c.is_a? Class
    end
  end

end
