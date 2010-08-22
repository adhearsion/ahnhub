class RepositoriesController < ApplicationController

  def index

    # TODO - sort by either newest repo or most downloaded or most watched

    @repositories = Repository.paginate :page => params[:page], :order => 'watchers DESC'

    respond_to do |format|
      format.html
      format.xml  { render :xml => @repositories }
    end
  end

  def show
    @repository = Repository.find(params[:id])

    respond_to do |format|
      format.html
      format.xml  { render :xml => @repository }
    end
  end

  # Used only by github
  def github_post_receive_hook
    payload = JSON.parse(params[:payload])

    # If Repo exists do not create another one but go ahead and update the data
    @repository = Repository.update_or_create_from_github_push(payload)

    if @repository
      head :ok
    else
      render :xml => @repository.errors, :status => :unprocessable_entity
    end
  end

end
