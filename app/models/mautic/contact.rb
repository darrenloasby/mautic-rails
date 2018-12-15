module Mautic
  class Contact < Model

    alias_attribute :first_name, :firstname
    alias_attribute :last_name, :lastname
    def self.in(connection)
      Proxy.new(connection, endpoint, default_params: { search: '!is:anonymous' })
    end

    def name
      "#{firstname} #{lastname}"
    end

    def add_do_not_contact(channel='email')
      console.log(self)
      save if id.blank?
      json = connection.request(:post, "api/contacts/#{id}/dnc/#{channel}/add")
    end
    
    def assign_attributes(source = nil)
      super
      self.attributes = {
        tags: (source['tags'] || []).collect{|t| Mautic::Tag.new(@connection, t)}
      } if source
    end

  end
end
