class CommitsController < ApplicationController

  before_filter :find_repository

  def index
    @commits = @repository.commits

    respond_to do |format|
      format.html
      format.xml  { render :xml => @commits }
    end
  end

  def show
    @commit = @repository.commits.find params[:id]

    respond_to do |format|
      format.html
      format.xml  { render :xml => @commit }
    end
  end

  private
  def find_repository
    @repository = Repository.find params[:repository_id]
  end

end
