class RepositoriesController < ApplicationController
  require 'rubygems'
  # require 'oauth2'
  require 'json'
  
  # before

  # GET /repositories
  # GET /repositories.xml
  def index
          
    # TODO - sort by either newest repo or most downloaded or most watched
    @repositories = Repository.paginate :page => params[:page], :order => 'watchers DESC'

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

    # If Repo exists do not create another one but go ahead and update the data
    if @repository.nil? or @repository.length < 1
      @repository = Repository.new
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

        # Add commit record
        @commit = Commit.new

        @commit.repository_id = @repository.id  
        @commit.shaid = push['commits']['id']
        @commit.url = push['commits']['url']
        @commit.authorname = push['commits']['author']['name']
        @commit.authoremail = push['commits']['author']['email']
        @commit.message = push['commits']['message']
        @commit.committime = push['commits']['timestamp']
        @commit.added = push['commits']['added']
        @commit.removed = push['commits']['removed']
        @commit.modified = push['commits']['modified']

        @commit.save

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
