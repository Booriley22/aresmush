module AresMUSH
  module Utils
    class TinkerCmd
      include Plugin
      include PluginWithoutSwitches
      include PluginRequiresLogin
            
      def want_command?(client, cmd)
        cmd.root_is?("tinker")
      end
      
      def crack!
      end
      
      def check_can_manage
        return t('dispatcher.not_allowed') if !Manage.can_manage_game?(client.char)
        return nil
      end
      
      def handle

        welcome_room = Game.master.welcome_room
        ooc_room = Game.master.ooc_room

      quiet_room = AresMUSH::Room.create(:name => "Quiet Room", :room_type => "OOC")
      rp_room_hub = AresMUSH::Room.create(:name => "RP Annex", :room_type => "OOC")

      4.times do |n|
          rp_room = AresMUSH::Room.create(:name => "RP Room #{n}", :room_type => "OOC")
          AresMUSH::Exit.create(:name => "#{n}", :source => rp_room_hub, :dest => rp_room)
        AresMUSH::Exit.create(:name => "O", :source => rp_room, :dest => rp_room_hub)
      end

      AresMUSH::Exit.create(:name => "RP", :source => ooc_room, :dest => rp_room_hub)
      AresMUSH::Exit.create(:name => "QR", :source => ooc_room, :dest => quiet_room)

      AresMUSH::Exit.create(:name => "O", :source => welcome_room, :dest => ooc_room)
      AresMUSH::Exit.create(:name => "O", :source => quiet_room, :dest => ooc_room)
      AresMUSH::Exit.create(:name => "O", :source => rp_room_hub, :dest => ooc_room)

        client.emit_success "Done!"
      end
    end
  end
end
