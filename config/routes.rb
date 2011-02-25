Ahnhub::Application.routes.draw do

  # map.github_post_receive_hook '/', :controller => 'repositories',
  #                                   :action => 'github_post_receive_hook',
  #                                   :conditions => {:method => :post}

  match "/" => "repositories#do_post_hook", :via => :post, :as => "do_post_hook"

  resources :repositories, :only => [:index, :show] do
    resources :commits, :only => [:index, :show]
  end

  match 'how' => 'pages#how'
  match 'about' => 'pages#about'

  root :to => "repositories#index"
end
