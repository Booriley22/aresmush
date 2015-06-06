module AresMUSH
  module Rooms
    class WorkCmd
      include Plugin
      include PluginRequiresLogin
      include PluginWithoutArgs

      def want_command?(client, cmd)
        cmd.root_is?("work") && cmd.switch.nil?
      end
      
      def check_work_set
        return t('rooms.work_not_set') if client.char.work.nil?
        return nil
      end
      
      def check_can_go_home
        return t('dispatcher.not_allowed') if !Rooms.can_go_home?(client.char)
        return nil
      end
      
      def handle
        char = client.char
        char.room.emit_ooc t('rooms.char_has_gone_work', :name => char.name)
        Rooms.move_to(client, char, char.work)
      end
    end
  end
end
