
class Bot::Commands::OpposedRoll < Bot::Commands::Abstract

  def self.help_message
    message = <<~HELP
      /#{self.command_name} [PROTAGONIST_DICE] [ANTAGONIST_DICE]
      with /#{self.command_name} you can roll your dice against someone / something.
    HELP
  end

  def execute
    raise Bot::Parser::MISFORMATTED_COMMAND unless 2 <= @arguments.size

    protagonist_roll = Bot::Roll.new @arguments.shift
    antagonist_roll = Bot::Roll.new @arguments.shift
    net_hits = protagonist_roll.hits - antagonist_roll.hits

    response = <<~RESULT
      /#{self.class.command_name} #{protagonist_roll.dice_count_formatted} #{antagonist_roll.dice_count_formatted}
      P: #{protagonist_roll.format_as_string}
      A: #{antagonist_roll.format_as_string}
      Net Hits: #{net_hits}
    RESULT

    response += "\nfailure\n" if net_hits < 0
    post_format response
  end

end
