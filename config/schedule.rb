# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
set :output, 'log/cron.log'
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
every 1.day do
  runner 'DailyDigestJob.perform_now'
end

every 1.minute do
  puts 'x'*500
  rake 'ts:index'
  # sleep 1
  # rake 'ts:start'
end

# Learn more: http://github.com/javan/whenever
