module AresMUSH
  module Rooms
    class ZoneCmd
      include Plugin
      include PluginRequiresLogin
      include PluginWithoutSwitches

      attr_accessor :name
      
      def want_command?(client, cmd)
        cmd.root_is?("zone")
      end
            
      def crack!
        self.name = titleize_input(cmd.args)
      end

      def check_can_build
        return t('dispatcher.not_allowed') if !Rooms.can_build?(client.char)
        return nil
      end

      def check_zone
        zones = ['Serve', 'Relig', 'Res', 'Lodge', 'Comm', 'Rec', 'Ooc']
        return t('rooms.zone_invalid') if !zones.include?(self.name)
        return nil
      end
      
      def handle
        if (self.name.nil?)
          client.room.zone = nil
          message = t('rooms.zone_cleared')
        else
          client.room.zone = self.name
          message = t('rooms.zone_set')
        end
        client.room.save!
        client.emit_success message
      end
    end
  end
end