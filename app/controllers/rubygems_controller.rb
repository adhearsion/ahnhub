class RubygemsController < ApplicationController

  respond_to :json

  def do_post_hook
    @repository = Rubygem.update_or_create_from_gemcutter_push JSON.parse(params[:payload])

    if @repository
      head :ok
    else
      render :xml => @repository.errors, :status => :unprocessable_entity
    end
  end

end
