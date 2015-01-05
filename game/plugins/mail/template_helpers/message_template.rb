module AresMUSH
  module Mail
    # Template for an individual mail message
    class MessageTemplate
      include TemplateFormatters
      
      def initialize(client, delivery)
        @client = client
        @char = client.char
        @delivery = delivery
        @message = delivery.message
      end
      
      def subject
        @message.subject
      end

      # Delivery date
      def date
        OOCTime.local_long_timestr(@client, @message.created_at)
      end
      
      def body
        @message.body
      end
      
      def author
        @message.author.name
      end
      
      def to
        to_list = @message.mail_deliveries.map { |d| d.character.nil? ? t('mail.deleted_recipient') : d.character.name }
        to_list.join(", ")
      end

      # Special message tags, like marked for deletion.
      def tags
        @delivery.trashed ? t('mail.trashed_tag') : ""
      end
    end
  end
end