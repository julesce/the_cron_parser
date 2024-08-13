require_relative 'element_parser'

class CronParser
  def initialize(cron_string)
    @cron_string = cron_string
  end

  # Parses the cron string provided, returning formatted output:
  #
  #   CronParser.new("*/15 0 1,15 * 1-5 /usr/bin/find").call
  #   #=>
  #   # Minute        0 15 30 45
  #   # Hour          0
  #   # Day of Month  1 15
  #   # Month         1 2 3 4 5 6 7 8 9 10 11 12
  #   # Day of Week   1 2 3 4 5
  #   # Command       /usr/bin/find
  def call
    return false unless valid_input?

    render_output
  end

  private

  attr_reader :cron_string, :parts

  def valid_input?
    if cron_string.nil? || cron_string.empty?
      puts "Error: Please supply a cron string as the first argument"
      return false
    end

    @parts = cron_string.split(' ')
    if parts.length != 6
      puts "Error: Please supply a valid cron string with 6 arguments"
      return false
    end

    true
  end

  def render_output
    full_result = [
      minute_output,
      hour_output,
      day_of_month_output,
      month_output,
      day_of_week_output,
      command_output,
    ].join("\n")

    puts full_result
  end

  def minute_output
    result = ElementParser.new(parts[0], lower_bound: 0, upper_bound: 59).call
    "#{heading("Minute")}#{result}"
  end

  def hour_output
    result = ElementParser.new(parts[1], lower_bound: 0, upper_bound: 23).call
    "#{heading("Hour")}#{result}"
  end

  def day_of_month_output
    result = ElementParser.new(parts[2], lower_bound: 1, upper_bound: 31).call
    "#{heading("Day of Month")}#{result}"
  end

  def month_output
    result = ElementParser.new(parts[3], lower_bound: 1, upper_bound: 12).call
    "#{heading("Month")}#{result}"
  end

  def day_of_week_output
    result = ElementParser.new(parts[4], lower_bound: 0, upper_bound: 7).call
    "#{heading("Day of Week")}#{result}"
  end

  def command_output
    "#{heading("Command")}#{parts[5]}"
  end

  def heading(text)
    text.ljust(14)
  end
end
