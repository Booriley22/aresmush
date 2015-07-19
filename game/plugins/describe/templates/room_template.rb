module AresMUSH
  module Describe
    # Template for a room.
    class RoomTemplate
      include TemplateFormatters
                            
      def initialize(room, client)
        @room = room
        @client = client
      end
      
      def display
        text = header_display()
        text << "%r%l2%r"
        text << desc_display()
        text << roomwiki_display()
        text << "%r%l2%r"
        text << players_display()
        text << "%r%r"
        text << exits_display()
        text << "%r%l1"
        
        text
      end
      
      def header_display
        text = "%l1%r"
        text << "#{zone_color(@room)}#{name}%xn #{area}%r"
        text << "#{ic_time} %x190~%xn %xh%xx(( #{ooc_time} )) %xn#{grid}"

        text
      end
      
      def desc_display
        text = ""
        # Weather is disabled by default.  Uncomment this line to show it
        # in room descs.
        text << "#{weather}"
        text << "#{description}"
        text << "#{details}"
        
        text
      end
      
      def players_display
        text = "%xg#{t('describe.players_title')}%xn "
        text << online_chars.map { |c| "%xh#{char_name(c)}%xn#{char_afk(c)}" }.join(", ")
        
        text
      end
      
      def exits_display
        text = "%xh%xy#{t('describe.exits_title')}%xn"
        exits.each_with_index do |e, i|
            
          # Linebreak every 2 exits.
          text << ((i % 2 == 0) ? "%r" : "")
          
          text << "#{exit_name(e)}"
          text << ""
          text << exit_destination(e)
        end
        
        if (exits.count == 0)
          text << "%r"
          text << t('describe.no_way_out')
        end
        
        if (@room.is_foyer)
          text << foyer()
        end

        text
      end
      
      # List of all exits in the room.
      def exits
        if (@room.is_foyer)
          non_foyer_exits
        else
          @room.exits.sort_by { |e| e.name }
        end
      end
      
      # List of online characters, sorted by name.      
      def online_chars
        @room.characters.select { |c| c.is_online? }.sort_by { |c| c.name }
      end
      
      def name
        left(@room.name, 40)
      end
      
      def description
        @room.description
      end
      
      # Available detail views.
      def details
        names = @room.details.keys
        return "" if names.empty?
        "%R%R%xh#{t('describe.details_available')}%xn #{names.sort.join(", ")}"
      end
      
      # Short IC date/time string
      def ic_time
        ICTime.ic_long_timestr ICTime.ictime
      end
      
      def area
        right(@room.area, 37)
      end
      
      # Room grid coordinates, e.g. (1,2)
      def grid
      text = "( %xh%xr#{@room.grid_x}%xn,%xh%xr#{@room.grid_y}%xn )"
      right( text, 34 )
      end

      def weather
         w = Weather.weather_for_area(@room.area)
         w ? center("#{w}%R%l2%r",80) : ""
      end
      
      def ooc_time
        OOCTime.local_short_timestr(@client, Time.now)
      end
      
      def foyer_exits
        @room.exits.select { |e| e.name.is_integer? }.sort_by { |e| e.name }
      end
      
      def non_foyer_exits
        @room.exits.select { |e| !e.name.is_integer? }.sort_by { |e| e.name }
      end
      
      # Special text displayed for the exits in a foyer.
      def foyer
        text = "%R%l2%R"
        text << center(t('describe.foyer_room_status'),78)
        foyer_exits.each_with_index do |e, i|
          if (!e.lock_keys.empty?)
            status = t('describe.foyer_room_locked')
          elsif (e.dest.characters.count == 0)
            status = t('describe.foyer_room_free')
          else
            status = t('describe.foyer_room_occupied')
          end
          text << "%r[space(10)]" if i % 2 == 0
          room_name = "#{e.dest.name} (#{status})"
          text << "%xh[#{e.name}]%xn #{left(room_name,29)}"
        end
        
        text
      end
      
      def char_name(char)
        char.name
      end

      def char_shortdesc(char)
        char.shortdesc ? " - #{char.shortdesc}" : ""
      end

      def roomwiki_display
        @room.roomwiki ? "%R#{center(@room.roomwiki, 80)}" : ""
      end
    
      # Shows the AFK message, if the player has set one, or the automatic AFK warning,
      # if the character has been idle for a really long time.
      def char_afk(char)
        if (char.is_afk?)
          msg = " %xy%xh<#{t('describe.afk')}>%xn"
          if (char.afk_message)
            msg = "#{msg} %xh%xy- %xn%xy((#{char.afk_message}))%xn"
          end
        elsif (char.client && Status.is_idle?(char.client))
          "%xy%xh<#{t('describe.idle')}>%xn"
        else
          ""
        end
      end
      
     def exit_name(e)
       locked = e.allow_passage?(@client.char) ? "" : "%xh%xr"
       color = zone_color(e.dest)
       text = "#{color}[%xn"
       text << "#{locked}#{e.name}"
       text << "#{color}]%xn"
       left(text, 5)
     end     
      def exit_destination(e)
        name = e.dest ? e.dest.name : t('describe.nowhere')
        str = "#{name}"
        left(str, 30)
      end

      def zone_color(room)
        return "%xc" if room.zone == "Serve"
        return "%xh%xc" if room.zone == "Gov"
        return "%xm" if room.zone == "Relig"
        return "%xh%xg" if room.zone == "Res"
        return "%xg" if room.zone == "Lodge"
        return "%xh%xb" if room.zone == "Comm"
        return "%xh%xy" if room.zone == "Rec"
      end

    end
  end
end