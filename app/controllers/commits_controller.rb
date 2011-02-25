class CommitsController < ApplicationController

  respond_to :html, :xml

  before_filter :find_repository

  def index
    @commits = @repository.commits
    respond_with @commits
  end

  def show
    @commit = @repository.commits.find params[:id]
    respond_with @commit
  end

  private

    def find_repository
      @repository = Repository.find params[:repository_id]
    end

end
