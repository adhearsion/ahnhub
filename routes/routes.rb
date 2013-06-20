class AhnHub < Sinatra::Base
  get '/' do
    @plugins_view = Plugin.reverse_order(:last_updated).all
    haml :index
  end

  get '/how' do
    haml :how
  end

  get '/about' do
    haml :about
  end

  post '/search' do
    query = params['query']
    result = Plugin.where(Sequel.like(:name, "%#{query}%")).or(
                          Sequel.like(:desc, "%#{query}%")).or(
                          Sequel.like(:owner, "%#{query}%"))
    @search_string = query
    @plugins_view = result.reverse_order(:last_updated).all
    haml :index
  end

  post '/github' do
    ParseGithubHook JSON.parse(params[:payload])
    @plugins_view = Plugin.reverse_order(:last_updated).all
    haml :index
  end

  post '/rubygem_hook' do
    payload = JSON.parse(request.body.read)
    RubygemUpdate.handle_hook(payload)
  end
end