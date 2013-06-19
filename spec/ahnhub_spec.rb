require 'spec_helper'

describe AhnHub do
  describe "GET '/'" do
    it "returns something about adhearsion" do
      get '/'
      last_response.should be_ok
      last_response.body.should match(/adhearsion/)
    end
  end

  describe "POST '/rubygem_hook'" do
    after { post '/rubygem_hook', RUBY_SAMPLE_RESPONSE.to_json, {'Content-Type' => 'application/json'} }

    it "passes the info along to RubyGemUpdate" do
      RubygemUpdate.should_receive(:handle_hook)
    end
  end
end