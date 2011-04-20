class RepositoriesController < ApplicationController

  respond_to :json

  def do_post_hook
    @repository = Repository.update_or_create_from_github_push JSON.parse(params[:payload])

    if @repository
      head :ok
    else
      render :xml => @repository.errors, :status => :unprocessable_entity
    end
  end

end
