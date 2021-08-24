
class Bot::Commands::Abstract

  def initialize arguments
    @arguments = arguments
  end

  def self.command_name
    self.name.underscore.gsub(/^(.*)\//, '')
  end

  def post_format response
    response = response.split("\n").map(&:strip).join("\n")
    response += "\n" unless "\n" == response[-1]
  end

end
