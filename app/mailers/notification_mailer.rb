class NotificationMailer < ActionMailer::Base
  default :from => "from@example.com"

  def new_project(project)
    @project = project
    mail :to => 'bklang@mojolingo.com', :subject => 'New project added'
  end
end
