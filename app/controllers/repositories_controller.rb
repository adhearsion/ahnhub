class RepositoriesController < ApplicationController

  respond_to :html, :xml

  def index
    # TODO - sort by either newest repo or most downloaded or most watched
    @repositories = Repository.paginate :page => params[:page], :order => 'watchers DESC'
    respond_with @repositories
  end

  def show
    @repository = Repository.find(params[:id])
    respond_with @repository
  end

  def do_post_hook
    if params.has_key?(:payload)
      # Assume this is a Github post-receive hook
      payload = JSON.parse(params[:payload])
      @repository = Repository.update_or_create_from_github_push(payload)
    elsif params.has_key?('gem_uri')
      # Assume this is a RubyGems.org webhook
      @repository = Repository.update_or_create_from_rubygems_webhook(params)
    end

    # If Repo exists do not create another one but go ahead and update the data

    if @repository
      head :ok
    else
      render :xml => @repository.errors, :status => :unprocessable_entity
    end
  end

end
