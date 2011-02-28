class NotificationMailer < ActionMailer::Base
  default :from => "from@example.com"

  def new_repository(repository)
    @repository = repository
    mail :to => 'bklang@mojolingo.com', :subject => 'New repository added'
  end
end
