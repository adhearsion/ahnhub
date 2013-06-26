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
    query  = params['query']
    @search_string = query

    result = GithubRepo.where(Sequel.like(:name, "%#{query}%")).or(
                              Sequel.like(:desc, "%#{query}%")).or(
                              Sequel.like(:owner, "%#{query}%"))
    if result.all == nil
      result = Rubygem.where(Sequel.like(:name, "%#{query}%")).or(
                             Sequel.like(:info, "%#{query}%")).or(
                             Sequel.like(:homepage_uri, "%#{query}%"))
    end


    @plugins_view = result.reverse_order(:last_updated).all.map do |r|
      Plugin.find(id: r.plugin_id) rescue nil
    end.delete_if {|r| r == nil}

    haml :index
  end

  post '/github' do
    ParseGithubHook JSON.parse(params[:payload])
    @plugins_view = Plugin.reverse_order(:last_updated).all
    haml :index
  end

  post '/gem' do
    payload = JSON.parse(request.body.read)
    RubygemUpdate.handle_hook(payload)
    "ok"
  end
end