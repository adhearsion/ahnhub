class RepositoriesController < ApplicationController

  respond_to :html, :xml

  def index
    # TODO - sort by either newest repo or most downloaded or most watched
    @repositories = Repository.search(params[:search]).paginate :page => params[:page], :order => 'updated_at DESC'
    respond_with @repositories
  end

  def show
    @repository = Repository.find(params[:id])
    respond_with @repository
  end

  def do_post_hook
    @repository = Repository.update_or_create_from_github_push JSON.parse(params[:payload])

    if @repository
      head :ok
    else
      render :xml => @repository.errors, :status => :unprocessable_entity
    end
  end

end
