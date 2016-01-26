namespace :i18n do

  def load_translations(locales)
    locales = [locales].flatten.uniq
    locales.each do |locale|
      file_path = Rails.root.join('config/locales', "#{locale}.yml")
      if File.exists?(file_path)
        translations = YAML.load_file(file_path)[locale]
        I18n.backend.store_translations(locale, translations, escape: false)
        puts "#{locale} load translations succeed"
      else
        puts "#{file_path} file does not exist"
      end
    end
  end

  # rake i18n:all_locales_load_translations
  desc 'i18n all locales load translations'
  task :all_locales_load_translations => :environment do
    load_translations(I18n.backend.available_locales)
  end

  # rake "i18n:locale_load_translations[zh-s-CN]"
  desc 'i18n locale load translations'
  task :locale_load_translations, [:locale] => :environment do |t, args|
    load_translations(args['locale'])
  end

end