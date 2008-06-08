module ActiveConference
  class Etc
    def self.balance
      ActiveConference::Resource.etc_get(:balance)['balance']
    end
  end
end
