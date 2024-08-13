require_relative 'lib/cron_parser'

cron_string = ARGV.first&.to_s&.strip
CronParser.new(cron_string).call
