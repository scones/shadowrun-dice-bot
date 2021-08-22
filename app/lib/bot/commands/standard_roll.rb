
class Bot::Commands::StandardRoll < Bot::Commands::Abstract

  def help_message
    <<~HELP
      /#{self.command_name} [DICE NUMBER] [THRESHOLD]
      with /#{self.command_name} you can roll your dice. add a number to roll a specific amount of dice (ie. /#{self.command_name} 5 ) and add two number for a specific amount and a threshold
    HELP
  end

  def execute
    dice_count = (@arguments.shift || 1).to_i
    threshold = @arguments.empty? ? nil : @arguments.shift.to_i

    rolls = dice.roll_6 dice_count
    hits = rolls.select{|roll| roll >= 5 }.count
    response = <<~RESULT
      /#{command_name} #{dice_count} #{threshold}
      Roll: #{rolls.join(' ')}
      Hits: #{hits}
    RESULT

    if threshold
      if hits >= threshold
        response += "\nsuccess"
      else
        response += "\nfailure"
      end
    end

    ones = rolls.select{|roll| roll == 1 }.count
    if ones > dice_count>>1
      if 0 == hits || (threshold && hits < threshold)
        response += "\ncritical glitch"
      else
        response += "\nglitch"
      end
    end

    response = response.split("\n").map(&:strip).join("\n")
    response += "\n" unless "\n" == response[-1]
  end

end
