module ApplicationHelper

  def link_to_repository_with_owner(repository)
    "<span class='owner'>" + link_to_github_user(repository.ownername) + "/</span>" + link_to_repository(repository)
  end

  def link_to_repository(repository)
    link_to(h(repository.name), h(repository.url))
  end

  def link_to_github_user(username)
    link_to h(username), "http://github.com/#{h(username)}"
  end
end
