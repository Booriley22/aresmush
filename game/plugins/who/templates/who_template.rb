module AresMUSH
  module Who
    class WhoTemplate < AsyncTemplateRenderer
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
        text = header(t('who.who_header'))
        chars_by_handle.each do |c|
          # Mild potential race condition between when the list was teed up and now.
          next if !c.client

          text << "%R"
          text << char_status(c)
          text << " "
          text << char_name_and_handle(c)
          text << " "
          text << char_gender(c)
          text << " "
          text << char_occupation(c)
          text << " "
          text << char_connected(c)
          text << " "
          text << char_idle(c)
        end
      
        text << footer()
      
        text
      end
    end 
  end
end
