
class Bot::Parser
  MISFORMATTED_COMMAND = "invalid syntax. see /help"
  UNKNOWN_COMMAND = "unknown command. see /help"

  def initialize message
    @message = message
  end

  def response
    validate

    command.execute
  rescue => e
    e.message
  end


  private


  def command
    @parts = @message.split(' ')
    @arguments = @parts.map(&:downcase)
    @slug = @arguments.shift.gsub(/^\//, '').gsub(/[^a-z0-9A-Z]/, '_')

    class_name = "Bot::Commands::#{@slug.camelize}"
    raise self.class::UNKNOWN_COMMAND unless command_exists? class_name
    @command = Object.const_get(class_name).new(@arguments)
  end

  def validate
    raise self.class::MISFORMATTED_COMMAND unless @message =~ /^\/[a-z\-A-Z_]+/
  end

  def command_exists? class_name
    klass = Object.const_get(class_name)
    return klass.is_a?(Class)
  rescue NameError
    return false
  end

end
