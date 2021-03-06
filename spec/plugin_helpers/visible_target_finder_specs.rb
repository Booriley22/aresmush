$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH
  describe VisibleTargetFinder do
    describe :find do
      before do
        @client = double
        Exit.stub(:where) { [] }
        Character.stub(:where) { [] }
      end

      it "should return the char for the me keword" do
        char = double
        @client.stub(:char) { char }
        result = VisibleTargetFinder.find("me", @client)
        result.target.should eq char
        result.error.should be_nil
      end

      it "should return the char's location for the here keyword" do
        room = double
        @client.stub(:room) { room }
        result = VisibleTargetFinder.find("here", @client)
        result.target.should eq room
        result.error.should be_nil
      end
      
      it "should ensure only a single result" do
        room = double
        room.stub(:id) { 1 }
        @client.stub(:room) { room }
        char1 = double
        char2 = double
        exit = double
        char1.stub(:room) { room }
        char2.stub(:room) { room }
        exit.stub(:source) { room }
        Character.should_receive(:find_all_by_name).with("A") { [char1, char2] }
        Exit.should_receive(:find_all_by_name).with("A") { [exit] }
        result = FindResult.new(nil, "an error")
        SingleResultSelector.should_receive(:select).with([char1, char2, exit]) { result }
        VisibleTargetFinder.find("A", @client).should eq result      
      end

      it "should remove nil results before selecting single target" do
        room = double
        room.stub(:id) { 1 }
        @client.stub(:room) { room }
        char = double
        char.stub(:room) { room }
        Character.stub(:find_all_by_name) { [char] }
        Exit.stub(:find_all_by_name) { [] }
        result = FindResult.new(char, nil)
        SingleResultSelector.should_receive(:select).with([char]) { result }
        VisibleTargetFinder.find("A", @client).should eq result      
      end
    end
    
    describe :with_something_visible do
      before do
        @client = double
        @object = double
        @object.stub(:name) { "obj name" }
      end
      
      it "should emit failure if the object isn't visible" do
        result = FindResult.new(nil, "error msg")
        VisibleTargetFinder.should_receive(:find).with("name", @client) { result }
        @client.should_receive(:emit_failure).with("error msg")
        VisibleTargetFinder.with_something_visible("name", @client) do |obj|
          raise "Should not get here."
        end
      end
      
      it "should not call the block with the object if it doesn't exist" do
        VisibleTargetFinder.stub(:find) { FindResult.new(nil, nil) }
        @client.stub(:emit_failure)
        VisibleTargetFinder.with_something_visible("name", @client) do |obj|
          raise "Should not get here."
        end
      end
            
      it "should call the block with the char if it exists" do
        VisibleTargetFinder.stub(:find) { FindResult.new(@object, nil) }
        VisibleTargetFinder.with_something_visible("name", @client) do |obj|
          @object.name.should eq "obj name"
        end
      end
    end
  end
end