module AresMUSH
  
  module Detailable
    def self.included(base)
      base.send :extend, ClassMethods   
      base.send :register_data_members
    end
    
    module ClassMethods
      def register_data_members
        field :details, :type => Hash, :default => {}
      end
    end
    
    def has_detail?(name)
      details.has_key?(name)
    end
    
    def detail(name)
      details[name]
    end
  end
      
  class Character
    include Detailable

    field :description, :type => String
    field :shortdesc, :type => String
    field :outfits, :type => Hash, :default => {}
    
    def has_outfit?(name)
      outfits.has_key?(name)
    end
    
    def outfit(name)
      outfits[name]
    end
  end
  
  class Room
    include Detailable

    field :description, :type => String
    field :shortdesc, :type => String

    def zone_color
      return "%xh%xb" if self.zone == "Comm"
      return "%xh%xy" if self.zone == "Lodge"
      return "%xh%xg" if self.zone == "Rec"
      return "%xh%xc" if self.zone == "Serve"
      return "%xm" if self.zone == "Relig"
      return "%xh%xr" if self.zone == "Res"
      return "%xh%xx" if self.zone == "OOC"
    end
  end
  
  class Exit
    include Detailable

    field :description, :type => String
    field :shortdesc, :type => String
  end    
end
