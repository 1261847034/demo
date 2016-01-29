require 'redis-namespace'
# 默认redis处理数据
redis_setting = RedisSettings.default
redis_connection = Redis.new(host: redis_setting.host, port: redis_setting.port, db: redis_setting.db)
$redis = Redis::Namespace.new(redis_setting.namespace, redis: redis_connection)

# redis处理i18n
I18N_LOCALES = YAML.load_file(Rails.root.join('config', 'locales.yml'))['locales']

module I18n
  module Backend
    class KeyValue
      # 设定了合法的 locales
      def available_locales
        I18N_LOCALES.each_with_object([]) do |(lang, countries), locales|
          locales << countries.map{|country| "#{lang}-#{country}"}
        end.flatten.uniq
      end
    end
  end
end

i18n_redis_setting = RedisSettings.i18n
i18n_redis_connection = Redis.new(host: i18n_redis_setting.host, port: i18n_redis_setting.port, db: i18n_redis_setting.db)
$i18n_redis = Redis::Namespace.new(i18n_redis_setting.namespace, redis: i18n_redis_connection)
I18n.backend = I18n::Backend::CachedKeyValueStore.new($i18n_redis)
Rails.application.config.i18n.available_locales += I18n.backend.available_locales #I18n::Backend::KeyValue.new($i18n_redis).available_locales

# 使用redis缓存
$redis_store = ActiveSupport::Cache::RedisStore.new(RedisSettings.cache.deep_symbolize_keys)