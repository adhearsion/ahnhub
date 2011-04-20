Ahnhub::Application.routes.draw do
  match "/" => "repositories#do_post_hook", :via => :post, :as => "do_post_hook"
  match "/gems" => "rubygems#do_post_hook", :via => :post, :as => "do_post_hook"

  resources :repositories, :only => [:index, :show] do
    resources :commits, :only => [:index, :show]
  end
  resources :projects, :only => [:index, :show]

  match 'how' => 'pages#how'
  match 'about' => 'pages#about'

  root :to => "projects#index"
end
