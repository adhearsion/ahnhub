class Project < ActiveRecord::Base
  has_one :rubygem
  has_one :repository

  after_create :send_admin_creation_notification

  def self.search(search)
    if search
      where(['name LIKE ? OR description LIKE ? OR ownername LIKE ?', *["%#{search}%"] * 3])
    else
      scoped
    end
  end

  def send_admin_creation_notification
    NotificationMailer.new_project(self).deliver
  end

  def name
    rubygem.andand.name || repository.andand.name || ''
  end

  def description
    rubygem.andand.info || repository.andand.description || ''
  end
end
