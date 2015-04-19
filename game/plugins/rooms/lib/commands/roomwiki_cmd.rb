module AresMUSH
  module Rooms
    class RoomWikiCmd
      include Plugin
      include PluginRequiresLogin
      include PluginWithoutSwitches

      attr_accessor :name
      
      def want_command?(client, cmd)
        cmd.root_is?("roomwiki")
      end
            
      def crack!
        self.name = cmd.args.nil? ? nil : trim_input(cmd.args)
      end

      def check_can_build
        return t('dispatcher.not_allowed') if !Rooms.can_build?(client.char)
        return nil
      end
      
      def handle
        if (self.name.nil?)
          client.room.roomwiki = nil
          message = t('rooms.roomwiki_cleared')
        else
          client.room.roomwiki = self.name
          message = t('rooms.roomwiki_set')
        end
        client.room.save!
        client.emit_success message
      end
    end
  end
end
