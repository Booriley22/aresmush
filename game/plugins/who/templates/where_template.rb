module AresMUSH
  module Who
    class WhereTemplate
      include TemplateFormatters
      
      # NOTE!  Because so many fields are shared between the who and where templates,
      # they are defined in these two modules, found in other files in this directory.
      include WhoCharacterFields
      include CommonWhoFields
    
      def initialize(online_chars)
        self.online_chars = online_chars
      end
      
      def display
        text = header(t('who.where_header'))
        active_rooms.each do |name, players|
         text << left("%r#{name}",52)
          text << players.join(" & ")
        end
        text << footer()
        text
     end

     def active_rooms
        rooms = {}
        self.online_chars.each do |char|
          room_name = who_room_name(char)
          if (rooms.has_key?(room_name))
            rooms[room_name] << char.name
          else
            rooms[room_name] = [ char.name ]
          end
        end
        return rooms
      end
    end 
	end
	end