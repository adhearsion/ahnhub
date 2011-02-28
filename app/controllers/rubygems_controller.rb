class RubygemsController < ApplicationController

  respond_to :html, :xml

  def index
    # TODO - sort by either newest repo or most downloaded or most watched
    @repositories = Rubygem.paginate :page => params[:page], :order => 'watchers DESC'
    respond_with @repositories
  end

  def show
    @repository = Rubygem.find(params[:id])
    respond_with @repository
  end

  def do_post_hook
    @repository = Rubygem.update_or_create_from_gemcutter_push JSON.parse(params[:payload])

    if @repository
      head :ok
    else
      render :xml => @repository.errors, :status => :unprocessable_entity
    end
  end

end
