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

    let(:rubygem_update) { RubygemUpdate.find(name: "testfoo123") }
    let(:rubygem)        { rubygem_update.rubygem }
    let(:plugin)         { rubygem.plugin }

    context "when no rubygem exists" do
      context "when no plugin exists" do
        it "creates a new plugin, rubygem" do
          post '/rubygem_hook', RUBY_SAMPLE_RESPONSE.to_json, {'Content-Type' => 'application/json'}

          rubygem_update[:name].should      == "testfoo123"
          rubygem_update[:downloads].should == 7
          rubygem_update[:version].should   == "0.0.2"
          rubygem_update[:authors].should   == "Justin Aiken"

          # <Rubygem @values={:id=>1, :plugin_id=>1, :last_updated=>nil, :name=>"testfoo123", :platform=>"ruby", :authors=>"Justin Aiken", :info=>"A test gem", :downloads=>"7", :project_uri=>"http://rubygems.org/gems/testfoo123", :gem_uri=>"http://rubygems.org/gems/testfoo123-0.0.2.gem", :homepage_uri=>nil, :wiki_uri=>nil, :documentation_uri=>nil, :mailing_list_uri=>nil, :source_code_uri=>nil, :bug_tracker_uri=>nil}>
          # <Plugin @values={:id=>1, :last_updated=>2013-06-20 10:28:25 -0400, :name=>"testfoo123", :description=>"A test gem", :authors=>"Justin Aiken", :rubygem_id=>1, :github_repo_id=>nil, :rubygem_name=>"testfoo123", :github_name=>nil}>
        end
      end

      context "when a plugin exists" do

        before do
          @plugin = Plugin.create(
            name: "testfoo123",
            github_name: "testfoo123",
            last_updated: Time.now - 300
          )
          post '/rubygem_hook', RUBY_SAMPLE_RESPONSE.to_json, {'Content-Type' => 'application/json'}
        end

        it "hooks into that plugin" do
          @plugin.reload
          @plugin.last_updated.should == rubygem_update.last_updated
        end
      end
    end

    context "when the rubygem already exists" do
      before do
        @rubygem = Rubygem.create(
          name: "testfoo123",
          last_updated: Time.now
        )
        @plugin = @rubygem.plugin
        post '/rubygem_hook', RUBY_SAMPLE_RESPONSE.to_json, {'Content-Type' => 'application/json'}
      end

      it "just creates the update, and attaches it" do
        recent_update = RubygemUpdate.last

        @plugin.reload.last_updated.should  == recent_update.last_updated
        @rubygem.reload.last_updated.should == recent_update.last_updated
      end
    end
  end
end