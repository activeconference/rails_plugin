module ActiveConference

  class Resource < ActiveResource::Base
    self.site = 'http://activeconference.net/api/v1/'
    requires_signage

    def self.api_key=(key)
      SignedResource::Connection.api_key = key
    end

    def self.api_secret=(secret)
      SignedResource::Connection.api_secret = secret
    end

    def self.etc_get(method)
      connection.get("#{prefix}etc/#{method}.xml")
    end
  end

end
