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

$i18n_redis = Redis.new(RedisSettings.i18n)
I18n.backend = I18n::Backend::CachedKeyValueStore.new($i18n_redis)
Rails.application.config.i18n.available_locales += I18n.backend.available_locales #I18n::Backend::KeyValue.new($i18n_redis).available_locales