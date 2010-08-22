ActionController::Routing::Routes.draw do |map|

  map.github_post_receive_hook '/', :controller => 'repositories',
                                    :action => 'github_post_receive_hook',
                                    :conditions => {:method => :post}

  map.resources :repositories, :only => [:index, :show] do |repositories|
    repositories.resources :commits, :only => [:index, :show]
  end

  map.connect 'how', :controller => 'pages', :action => 'how'
  map.connect 'about', :controller => 'pages', :action => 'about'

  map.root :controller => "repositories"

end
