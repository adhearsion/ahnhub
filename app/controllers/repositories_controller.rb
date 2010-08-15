class RepositoriesController < ApplicationController
  require 'json'

  # GET /repositories
  # GET /repositories.xml
  def index
    # @repositories = Repository.all
    @repositories = Repository.paginate :page => params[:page], :order => 'created_at DESC'
    

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @repositories }
    end
  end

  # GET /repositories/1
  # GET /repositories/1.xml
  def show
    @repository = Repository.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @repository }
    end
  end

  # GET /repositories/new
  # GET /repositories/new.xml
  def new
    @repository = Repository.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @repository }
    end
  end

  # GET /repositories/1/edit
  def edit
    @repository = Repository.find(params[:id])
  end

  # POST /repositories
  # POST /repositories.xml
  def create
    # @repository = Repository.new(params[:repository])
    push = JSON.parse(params[:payload])
    
    @repository = Repository.find_by_url(push['repository']['url'])


    if @repository

    else
      @repository.new
    end
    
    @repository.name = push['repository']['name']
    @repository.description = push['repository']['description']
    @repository.url = push['repository']['url']
    @repository.watchers = push['repository']['watchers']
    @repository.forks = push['repository']['forks']
    @repository.privateflag = push['repository']['private']
    @repository.homepage = push['repository']['homepage']
    @repository.ownername = push['repository']['owner']['name']
    @repository.owneremail = push['repository']['owner']['email']
    
    respond_to do |format|
      if @repository.save
        format.html { redirect_to(@repository, :notice => 'Repository was successfully created.') }
        format.xml  { render :xml => @repository, :status => :created, :location => @repository }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @repository.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /repositories/1
  # PUT /repositories/1.xml
  def update
    @repository = Repository.find(params[:id])

    respond_to do |format|
      if @repository.update_attributes(params[:repository])
        format.html { redirect_to(@repository, :notice => 'Repository was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @repository.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /repositories/1
  # DELETE /repositories/1.xml
  def destroy
    @repository = Repository.find(params[:id])
    @repository.destroy

    respond_to do |format|
      format.html { redirect_to(repositories_url) }
      format.xml  { head :ok }
    end
  end
end
