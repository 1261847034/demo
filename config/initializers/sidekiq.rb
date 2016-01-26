Sidekiq.configure_server do |config|
  config.redis = { url: "redis://#{RedisSettings.host}:#{RedisSettings.port}/#{RedisSettings.db}" }
end

Sidekiq.configure_client do |config|
  config.redis = { url: "redis://#{RedisSettings.host}:#{RedisSettings.port}/#{RedisSettings.db}" }
end