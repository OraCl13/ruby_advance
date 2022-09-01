# frozen_string_literal: true

set :output, 'log/cron.log'

every 1.day do
  runner 'DailyDigestJob.perform_now'
end

every 1.minute do
  puts 'XXXXXX' * 1000
  rake 'ts:rebuild'
end
