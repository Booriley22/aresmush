module AresMUSH
  module Friends
    class FriendRemoveCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
      
      attr_accessor :name
      
      def initialize
        self.required_args = ['name']
        self.help_topic = 'friends'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("friend") && cmd.switch_is?("remove")
      end
      
      def crack!
        self.name = cmd.args
      end
      
      def handle
        if (self.name.start_with?("@"))
          Friends.remove_handle_friend(client, self.name)
        else
          error = Friends.remove_friend(client.char, self.name)
          if (error)
            client.emit_failure error
          else
            client.emit_success t('friends.friend_removed', :name => self.name)
          end   
        end     
      end
    end
  end
end
