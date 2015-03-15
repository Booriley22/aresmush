module AresMUSH
  module Weather
    class WeatherCmd
      include Plugin
      include PluginRequiresLogin
      include PluginWithoutSwitches
      include PluginWithoutArgs
           
      def want_command?(client, cmd)
        cmd.root_is?("weather")
      end
      
      def handle
        client.emit BorderedDisplay.text t('weather.weather', :weather => Weather.weather)
      end
    end
  end
end
