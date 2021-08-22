
class Bot::Commands::Abstract

  def initialize arguments
    @arguments = arguments
  end

  def command_name
    self.class.name.underscore.gsub(/^(.*)\//, '')
  end

  def dice
    @dice ||= Dice.new
  end
end
