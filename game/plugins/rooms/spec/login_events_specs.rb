require_relative "../../plugin_test_loader"

module AresMUSH
  module Rooms
    describe LoginEvents do
      include GameTestHelper

      before do
        @client = double(Client)
        @client.stub(:name) { "Bob" }

        @room = double
        @client.stub(:room) { @room }

        Describe.stub(:get_desc)
        @room.stub(:emit_ooc)
        
        @login = LoginEvents.new
        AresMUSH::Locale.stub(:translate).with("rooms.char_has_arrived", { :name => "Bob" }) { "char_has_arrived" }
        stub_game_master
      end
      
      describe :on_char_connected_event do      
        it "should emit the desc of the char's last location" do
          Rooms.should_receive(:emit_here_desc).with(@client)
          @login.on_char_connected_event CharConnectedEvent.new(@client)
        end
      end
      
      describe :on_char_disconnected_event do   
        before do
          @char = double
          @client.stub(:char) { @char }
          @welcome_room = double
          game.stub(:welcome_room) { @welcome_room }
        end
           
        it "should send guests home to the welcome room" do
          @char.stub(:is_guest?) { true }
          Rooms.should_receive(:move_to).with(@client, @char, @welcome_room)
          @login.on_char_disconnected_event CharDisconnectedEvent.new(@client)
        end

        it "should not move around regular characters" do
          @char.stub(:is_guest?) { false }
          Rooms.should_not_receive(:move_to)
          @login.on_char_disconnected_event CharDisconnectedEvent.new(@client)
        end
      end
    end
  end
end