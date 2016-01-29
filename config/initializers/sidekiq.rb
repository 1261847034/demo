redis_setting = RedisSettings.default
Sidekiq.configure_server do |config|
  config.redis = { url: "redis://#{redis_setting.host}:#{redis_setting.port}/#{redis_setting.db}" }
end

Sidekiq.configure_client do |config|
  config.redis = { url: "redis://#{redis_setting.host}:#{redis_setting.port}/#{redis_setting.db}" }
end