require 'spec_helper'

describe RubygemsController do

  describe "#do_post_hook" do

    let(:fake_push) { FakeGem.new }

    it "should be installed on the root path on POSTs" do
      { :post => "/gems" }.should route_to(:controller => controller.controller_name, :action => 'do_post_hook')
    end

    it "should properly create a Rubygem" do
      Rubygem.destroy_all
      post :do_post_hook, :payload => fake_push.gem_metadata.to_json
      response.should be_success

      Rubygem.count.should == 1

      repo = Rubygem.first
      repo.name.should == fake_push.name
    end

  end

end
