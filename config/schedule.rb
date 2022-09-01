set :output, 'log/cron.log'

every 1.day do
  runner 'DailyDigestJob.perform_now'
end

every 1.minute do
  rake 'ts:rebuild'
end
