require 'spec_helper'

describe ProjectsController do

  describe "#index" do
    it "should be installed on the root path on GETs" do
      { :get => "/" }.should route_to(:controller => controller.controller_name, :action => 'index')
    end
  end

end
