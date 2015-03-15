module AresMUSH
  module Weather
    describe Weather
      
      it "should subtract a year offset" do
        Global.stub(:config) {{ "ictime" => {  "day_offset" => 0, "year_offset" => -300 }}}
        Date.stub(:today) { Date.new(2014, 01, 27) }
        Weather.Weather.should eq Date.new(1714, 01, 27)
      end      

      it "should add a year offset" do
        Global.stub(:config) {{ "Weather" => { "day_offset" => 0, "year_offset" => 300 }}}
        Date.stub(:today) { Date.new(2014, 01, 27) }
        Weather.Weather.should eq Date.new(2314, 01, 27)
      end      
      
      it "should handle a day offset" do
        Global.stub(:config) {{ "Weather" => { "day_offset" => 2, "year_offset" => 100 }}}
        Date.stub(:today) { Date.new(2014, 01, 27) }
        Weather.Weather.should eq Date.new(2114, 01, 29)
      end

      it "should handle a day offset across month boundaries" do
        Global.stub(:config) {{ "Weather" => { "day_offset" => -2, "year_offset" => 100 }}}
        Date.stub(:today) { Date.new(2014, 01, 01) }
        Weather.Weather.should eq Date.new(2113, 12, 30)
      end
    end
  end
end

