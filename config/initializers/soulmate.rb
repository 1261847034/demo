redis_setting = RedisSettings.soulmate
redis_connection = Redis.new(host: redis_setting.host, port: redis_setting.port, db: redis_setting.db)
$soulmate_redis = Redis::Namespace.new(redis_setting.namespace, redis: redis_connection)
Soulmate.redis = $soulmate_redis
Soulmate.min_complete = 1
