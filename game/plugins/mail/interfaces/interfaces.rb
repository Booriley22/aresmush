module AresMUSH
  module Mail
    def self.send_mail(names, subject, body, client)
      author = client.nil? ? Game.master.system_character : client.char
      
      msg = MailMessage.create(subject: subject, 
        body: body, 
        author: author)

      recipients = []
      names.each do |name|
        result = ClassTargetFinder.find(name, Character, client)
        if (!result.found?)
          if (client)
            client.emit_failure(t('mail.invalid_recipient', :name => name))
          end
          return false
        end
        recipients << result.target
      end
      
      recipients.each do |r|
        MailDelivery.create(message: msg, character: r)
        receive_client = Global.client_monitor.find_client(r)
        if (!receive_client.nil?)
          receive_client.emit_ooc t('mail.new_mail', :from => author.name, :subject => msg.subject)
        end
      end
      
      return true
    end
  end
end