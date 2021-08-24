
class Bot::Roll

  attr_accessor :is_fate, :dice_count, :rolls

  def initialize string
    @dice_count = string.nil? ? 1 : (string.to_i)
    @is_fate = string =~ /\+$/

    @rolls = dice.roll_6 dice_count
    @hits = @rolls.select{|roll| roll >= 5 }.count
    @ones = @rolls.select{|roll| roll == 1 }.count
  end

  def hits
    @is_fate ? @hits + 2 : @hits
  end

  def format_as_string
    @rolls.join(' ')
  end

  def emoji_formatted_roll
    @rolls.map{|roll| [9855 + roll].pack('U*').first }.join(' ')
  end

  def formatted_success threshold
    if threshold
      if @hits >= threshold
        "\nsuccess"
      else
        "\nfailure"
      end
    else
      ""
    end
  end

  def formatted_glitch threshold
    if @ones > @dice_count>>1
      if 0 == @hits || (threshold && @hits < threshold)
        "\ncritical glitch"
      else
        "\nglitch"
      end
    else
      ""
    end
  end

  def dice_count_formatted
    string = "#{dice_count}"
    string += "+" if @is_fate
    string
  end


  private


  def dice
    @dice ||= Dice.new
  end

end
