require 'spec_helper'

describe AhnHub do
  describe "GET '/'" do
    it "returns something about adhearsion" do
      get '/'
      last_response.should be_ok
      last_response.body.should match(/adhearsion/)
    end
  end
end