require 'I18n'
require "i18n/backend/fallbacks" 
  
# Short global alias for translate and localize
def t(str, *args)
  AresMUSH::Locale.translate(str, *args)
end

def l(object, options = {})
  AresMUSH::Locale.localize(object, options)
end
  
module AresMUSH  
  
  
  class Locale
    def initialize(config_reader, path)
      @path = path
      @config_reader = config_reader     
    end
        
    def locale
      I18n.locale
    end
    
    def default_locale
      I18n.default_locale
    end
    
    def setup
      load_translations
      set_locale
    end
    
    def self.translate(str, *args)  
      I18n.t(str, *args)
    end
    
    def self.localize(object, options = {})
      if (object.is_a?(Date) || object.is_a?(Time))
        I18n.l(object, options)
      else
        sep = t('number.format.separator')
        object.to_s.gsub(/\./, sep)
      end
    end
    
    def delocalize(object, options = {})
      if (object.is_a?(Date) || object.is_a?(Time))
        # Not current supported
        object.to_s
      else
        sep = t('number.format.separator')
        object.to_s.gsub(/#{sep}/, ".")
      end
    end
    
    private
    
    def load_translations
      I18n.load_path = []
      Dir.foreach("#{@path}") do |f| 
        next if (File.directory?(f))
        I18n.load_path << "#{@path}/#{f}"
      end
    end
    
    def set_locale
      I18n.locale =  @config_reader.config['server']['locale']
      I18n::Backend::Simple.send(:include, I18n::Backend::Fallbacks)
      I18n.default_locale = @config_reader.config['server']['default_locale']
    end
  end
end