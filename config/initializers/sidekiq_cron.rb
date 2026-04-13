if Sidekiq.server?
  begin
    Sidekiq::Cron::Job.create(
    name: 'Daily Report - 9AM UTC (5PM HKT)',
    cron: '0 9 * * *', 
    class: 'DailyReportWorker',
    queue: 'default')
  rescue RedisClient::CannotConnectError, Errno::ECONNREFUSED
    puts "Redis is unavailable - skipping Sidekiq Cron setup"
  end 
end
