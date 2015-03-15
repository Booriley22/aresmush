module AresMUSH
  module Describe
    class GlanceCmd
      include Plugin
      include PluginRequiresLogin
      include PluginWithoutSwitches
      include PluginWithoutArgs

      def want_command?(client, cmd)
        cmd.root_is?("glance")
      end

      def handle
      online_chars = client.char.room.characters.select { |c| c.client }
      list = online_chars.map { |c| glance_view(c) }
      client.emit BorderedDisplay.list list
      end

      def glance_view(char)
      "%xh#{char.fullname}%xn %x190-%xn A #{char.age} year old #{char.gender} with #{char.hair} hair, #{char.eyes} eyes and #{char.skin} complexion. Standing at #{char.height} with a #{char.physique} physique. #{char.shortdesc} #{char.subjective_pronoun} played by is: #{char.actor}."
      end
    end
   end
  end