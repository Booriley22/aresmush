module AresMUSH
  module Who
    class WhereTemplate < AsyncTemplateRenderer
      include TemplateFormatters
      
      # NOTE!  Because so many fields are shared between the who and where templates,
      # they are defined in these two modules, found in other files in this directory.
      include WhoCharacterFields
      include CommonWhoFields
    
      def initialize(online_chars, client)
        self.online_chars = online_chars
        super client
      end
      
      def build
        text = header(t('who.where_header'))
        active_rooms.sort_by { |r, v| r }.each do |name, info|
        players = info[:chars]
        color = info[:color]
         text << left("%r#{color}#{name}%xn",51)
         text << " "
         text << players.join(", ")
        end
        text << footer()
        text
     end

     def active_rooms
        rooms = {}
        self.online_chars.each do |char|
          room_name = Who.who_room_name(char)
          if (rooms.has_key?(room_name))
            rooms[room_name][:chars] << char.name
          else
            rooms[room_name] = 
               { :chars => [ char.name ],
                  :color => char.room.zone_color }
          end
        end
        return rooms
      end
    end
  end
end
