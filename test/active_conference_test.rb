require File.dirname(__FILE__)+'/../../../../config/environment.rb'
require 'test/unit'

require File.dirname(__FILE__)+'/../lib/active_conference.rb'
class ActiveConferenceTest < Test::Unit::TestCase

  def test_util_random_string
    assert_equal 27, ActiveConference::Util.random_string(27).length
    assert_match /^[a-zA-Z0-9]{15}$/, ActiveConference::Util.random_string(15)
    assert_not_equal ActiveConference::Util.random_string(6), ActiveConference::Util.random_string(6)
  end

end
