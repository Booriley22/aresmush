module AresMUSH
  module Utils
    class RenameCmd
      include Plugin
      include PluginWithoutSwitches
      include PluginRequiresArgs
      
      attr_accessor :target
      attr_accessor :name
            
      def initialize
        self.required_args = ['target']
        self.required_args = ['name']
        self.help_topic = 'rename'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("rename")
      end
      
      def crack!
        cmd.crack!(/(?<target>[^\=]+)\=(?<name>.+)/)
        self.target = trim_input(cmd.args.target)
        self.name = trim_input(cmd.args.name)
      end

      def check_can_manage
        return t('dispatcher.not_allowed') if !Manage.can_manage?(client.char)
        return nil
      end

      def handle
        find_result = VisibleTargetFinder.find(self.target, client)
        
        if (!find_result.found?)
          find_result = AnyTargetFinder.find(self.target, client)
        end
        
        if (!find_result.found?)
          client.emit_failure(find_result.error)
          return
        end
        target = find_result.target
        
        if (target.class == Character)
          name_validation_msg = Login.check_char_name(self.name)
          if (!name_validation_msg.nil?)
            client.emit_failure(name_validation_msg)
            return
          end
        end
        
        if (target.class == Exit)
          if (target.source.has_exit?(self.name))
            client.emit_failure(t('manage.exit_already_exists'))
            return
          end
        end
          
        target.name = self.name
        target.save!
        client.emit_success t('manage.object_renamed', :name => self.name)
      end
    end
  end
end