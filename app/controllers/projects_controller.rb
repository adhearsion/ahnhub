class ProjectsController < ApplicationController

  respond_to :html

  def index
    # TODO - sort by either newest repo or most downloaded or most watched
    @projects = Project.search(params[:search]).paginate :page => params[:page], :order => 'updated_at DESC'
    respond_with @projects
  end

  def show
    @project = Project.find(params[:id])
    respond_with @project
  end

end
