module ActiveConference
  class Participant < ActiveConference::Resource
    class << self
      def site
        @site ||= URI.parse("#{super}conferences/:conference_id")
      end
    end
  end
end
