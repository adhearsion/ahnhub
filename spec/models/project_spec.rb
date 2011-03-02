require 'spec_helper'

describe Project do

  describe "metadata should come from" do
    describe "rubygem if available" do
      let(:rubygem) { Factory.create :rubygem }

      subject { Factory.create :project, :rubygem => rubygem }

      it { puts rubygem.inspect }

      its(:rubygem) { should == rubygem }
      its(:name) { should == rubygem.name }
      its(:description) { should == rubygem.info }
    end

    describe "or repository" do
      let(:repository) { Factory.create :repository }

      subject { Factory.create :project, :repository => repository }

      its(:repository) { should == repository }
      its(:name) { should == repository.name }
      its(:description) { should == repository.description }
    end

    describe "or default to empty" do
      subject { Factory.create :project }

      its(:name) { should == '' }
      its(:description) { should == '' }
    end
  end

  describe "on creation" do
    it "should deliver the admin notification email" do
      project = Project.new
      mail = mock('new_project_mail')
      mail.should_receive(:deliver)
      NotificationMailer.should_receive(:new_project).with(project).and_return(mail)
      project.save
    end
  end

end
