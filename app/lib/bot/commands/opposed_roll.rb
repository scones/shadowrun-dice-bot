
class Bot::Commands::OpposedRoll < Bot::Commands::Abstract

  def help_message
    <<~HELP
      /#{self.command_name} [PROTAGONIST_DICE] [ANTAGONIST_DICE]
      with /#{self.command_name} you can roll your dice against someone / something.
    HELP
  end

  def execute
    raise Bot::Parser::MISFORMATTED_COMMAND unless 2 <= @arguments.size
    protagonist_dice_count = @arguments.shift.to_i
    antagagonist_dice_count = @arguments.shift.to_i

    protagonist_dice_rolls = dice.roll_6 protagonist_dice_count
    antagonist_dice_rolls = dice.roll_6 antagagonist_dice_count
    protagonist_hits = protagonist_dice_rolls.select{|roll| roll >= 5 }.count
    antagonist_hits = antagonist_dice_rolls.select{|roll| roll >= 5 }.count
    net_hits = protagonist_hits - antagonist_hits
    response = <<~RESULT
      /#{command_name} #{protagonist_dice_count} #{antagagonist_dice_count}
      P: #{protagonist_dice_rolls.join(' ')}
      A: #{antagonist_dice_rolls.join(' ')}
      Net Hits: #{net_hits}
    RESULT

    response += "\nfailure\n" if net_hits < 0
    response
  end

end
