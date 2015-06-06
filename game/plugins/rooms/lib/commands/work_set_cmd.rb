module AresMUSH
  module Rooms
    class WorkSetCmd
      include Plugin
      include PluginRequiresLogin
      include PluginWithoutArgs

      def want_command?(client, cmd)
        cmd.root_is?("work") && cmd.switch_is?("set")
      end
      
      def check_can_go_home
        return t('dispatcher.not_allowed') if !Rooms.can_go_home?(client.char)
        return nil
      end
      
      def handle
        client.emit_ooc t('rooms.work_set')
        client.char.work = client.char.room
        client.char.save!
      end
    end
  end
end
