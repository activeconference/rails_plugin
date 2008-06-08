module ActiveConference
  class Util
    def self.random_string(length = 8)
      chars = ("a".."z").to_a + ("0".."9").to_a + ("A".."Z").to_a
      Array.new(length, '').collect{chars[rand(chars.size)]}.join 
    end
  end
end
