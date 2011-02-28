require 'spec_helper'

describe NotificationMailer do
  include EmailSpec::Helpers
  include EmailSpec::Matchers
  include Rails.application.routes.url_helpers

  before(:all) { @repository = Factory.create :repository }

  subject { NotificationMailer.new_repository(@repository) }

  it "should be set to be delivered to the email passed in" do
    should deliver_to('bklang@mojolingo.com')
  end

  it "should contain text indicating that a new repository has been added" do
    should have_body_text(/new repository/)
  end

  it "should contain a link to the repository" do
    should have_body_text(repository_path(@repository))
  end

  it "should have the correct subject" do
    should have_subject('New repository added')
  end

end
