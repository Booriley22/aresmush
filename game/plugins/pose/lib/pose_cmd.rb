module AresMUSH
  module Pose
    class PoseCmd
      include Plugin
      include PluginRequiresLogin

      def want_command?(client, cmd)
        (cmd.root_is?("ooc") && !cmd.args.nil?) ||
        cmd.root_is?("emit") ||
        cmd.root_is?("pose") || 
        cmd.root_is?("say")
      end
      
      def handle
        Pose.emit_pose(client, message, cmd.root_is?("emit"))
      end
      
      def log_command
        # Don't log poses
      end
      
      def message
        if (cmd.root_is?("emit"))
          return PoseFormatter.format(client.name, "\\#{cmd.args}")
        elsif (cmd.root_is?("pose"))
          return PoseFormatter.format(client.name, ":#{cmd.args}")
        elsif (cmd.root_is?("ooc"))
          msg = PoseFormatter.format(client.name, "#{cmd.args}")
          color = Global.read_config("pose", "ooc_color")
          return "#{color}<OOC>%xn #{msg}"
        end
        return PoseFormatter.format(client.name, "\"#{cmd.args}")
      end
    end
  end
end
