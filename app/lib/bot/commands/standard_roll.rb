
class Bot::Commands::StandardRoll < Bot::Commands::Abstract

  def self.help_message
    <<~HELP
      /#{self.command_name} [DICE NUMBER] [THRESHOLD]
      with /#{self.command_name} you can roll your dice. add a number to roll a specific amount of dice (ie. /#{self.command_name} 5 ) and add two number for a specific amount and a threshold
    HELP
  end

  def execute
    roll = Bot::Roll.new @arguments.shift
    threshold = @arguments.empty? ? nil : @arguments.shift.to_i

    response = <<~RESULT
      /#{self.class.command_name} #{roll.dice_count_formatted} #{threshold}
      Roll: #{roll.format_as_string}
      Hits: #{roll.hits}
    RESULT

    response += roll.formatted_success threshold
    response += roll.formatted_glitch threshold

    post_format response
  end

end
