require 'spec_helper'

describe NotificationMailer do
  include EmailSpec::Helpers
  include EmailSpec::Matchers
  include Rails.application.routes.url_helpers

  before(:all) { @project = Factory.create :project }

  subject { NotificationMailer.new_project(@project) }

  it { should deliver_to('bklang@mojolingo.com') }
  it { should have_body_text(/new project/) }
  it { should have_body_text(project_path(@project)) }
  it { should have_subject('New project added') }

end
