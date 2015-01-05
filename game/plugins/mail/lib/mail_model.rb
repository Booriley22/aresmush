module AresMUSH
  class Character
    has_many :sent_mail, :class_name => "AresMUSH::MailMessage", :inverse_of => 'author', order: :created_at.asc
    has_many :all_mail, :class_name => "AresMUSH::MailDelivery", :inverse_of => 'character', order: :created_at.asc, :dependent => :nullify
    field :mail_compose_subject, :type => String
    field :mail_compose_to, :type => Array
    field :mail_compose_body, :type => String
    
    def mail
      all_mail.select { |m| !m.purged }
    end
    
    def unread_mail
      mail.select { |m| !m.read }
    end
  end
    
  class MailMessage
    include Mongoid::Document
    include Mongoid::Timestamps
    
    field :subject, :type => String
    field :body, :type => String
    
    belongs_to :author, :class_name => "AresMUSH::Character", :inverse_of => 'sent_mail'    
    has_many :mail_deliveries, :inverse_of => 'message'
  end
    
  class MailDelivery
    include SupportingObjectModel
      
    belongs_to :character, :inverse_of => :mail
    belongs_to :message, :class_name => "AresMUSH::MailMessage"
      
    field :read, :type => Boolean  
    field :trashed, :type => Boolean  
    field :purged, :type => Boolean
  end
end