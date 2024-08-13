class ElementParser

  # Responsible for parsing an element of a cron string, and returning the relevant formatted output.
  # The parameters are:
  # <code>"input"</code>:: the element to parse, e.g. "*/15"
  # <code>"lower_bound"</code>:: the lower bound value by which to constrain the output
  # <code>"upper_bound"</code>:: the upper bound value by which to constrain the output
  def initialize(input, lower_bound:, upper_bound:)
    @input = input.strip
    @lower_bound = lower_bound
    @upper_bound = upper_bound
  end

  # Parses the input string based on lower and upper bound values:
  #   ElementParser.new("*/15", 0, 59).call #=> 0 15 30 45
  def call
    error_message = "### Warning: Unable to parse input"

    has_comma = proc { |value| value.include?(",") }
    has_step_values = proc { |value| value.include?("/") }
    has_range = proc { |value| value.include?("-") }
    is_integer = proc { |value| !!Integer(value) }

    case input
    when "*"
      render_all
    when has_comma
      render_comma
    when has_step_values
      render_step_values
    when has_range
      render_range(input)
    when is_integer
      render_integer
    else
      error_message
    end
  rescue StandardError => e
    "#{error_message} - Error: #{e.message}"
  end

  private

  attr_reader :input, :lower_bound, :upper_bound

  def render_integer
    Integer(input).clamp(lower_bound, upper_bound).to_s
  end

  def render_step_values
    parts = input.split("/")
    divisor = Integer(parts[1])

    if parts[0] == "*"
      render_step_value_part(lower_bound, upper_bound, divisor)
    elsif parts[0].include?("-")
      range_parts = parts[0].split("-")
      render_step_value_part(Integer(range_parts[0]), Integer(range_parts[1]), divisor)
    else
      raise StandardError, "Invalid Step Value"
    end
  end

  def render_step_value_part(lower_bound, upper_bound, divisor)
    iterations = (upper_bound - lower_bound) / divisor
    iterations += 1

    [].tap do |output|
      running_total = lower_bound
      iterations.times do
        output << running_total
        running_total += divisor
      end
    end.join(" ")
  end

  def render_range(text)
    parts = text.split("-")
    raise StandardError, "Invalid range" unless parts.length == 2

    render_range_parts(parts[0], parts[1])
  end

  def render_range_parts(lower_string, upper_string)
    lower = Integer(lower_string)
    upper = Integer(upper_string)

    lower = lower < lower_bound ? lower_bound : lower
    upper = upper > upper_bound ? upper_bound : upper

    [].tap do |output|
      (lower..upper).each do |i|
        output << i
      end
    end.join(" ")
  end

  def render_comma
    parts = input.split(",")
    result = []

    parts.each do |part|
      if part.include?("-")
        result << render_range(part)
      else
        result << part
      end
    end

    result.join(" ")
  end

  def render_all
    [].tap do |items|
      (lower_bound..upper_bound).each do |item|
        items << item
      end
    end.join(" ")
  end
end