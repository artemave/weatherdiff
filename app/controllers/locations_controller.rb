class LocationsController < ApplicationController
  before_filter :store_location, :only => [:index, :new, :show, :edit] #for redirect back after login
	before_filter { |c|
    # XXX nonsecure backdoor for jquery autocomplete
	  c.send(:authenticate) unless c.request.format.js? and c.action_name == 'index'
	}

  # GET /locations
  # GET /locations.xml
  def index
    respond_to do |format|
      format.html {
        @locations = Location.with_samples.all
        render :template => 'locations/index'
      }
      format.xml  { render :xml => @locations }
      format.js {
        # q and limit are coming from jQuery autocomplete plugin
        @locations = Location.find(:all, :conditions => ["name like ?", "%#{params[:q]}%"], :limit => params[:limit])
        render :text => @locations.map(&:name).join("\n")
      }
    end
  end

  # GET /locations/1
  # GET /locations/1.xml
  def show
    @location = Location.with_samples.find(params[:id])
    @sample_summaries = @location.sample_summaries.paginate(:page => params[:page])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @location }
    end
  end

  # GET /locations/new
  # GET /locations/new.xml
  def new
    @location = Location.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @location }
    end
  end

  # GET /locations/1/edit
  def edit
    @location = Location.find(params[:id])
  end

  # POST /locations
  # POST /locations.xml
  def create
    @location = Location.new(params[:location])

    respond_to do |format|
      if @location.save
        flash[:notice] = 'Location was successfully created.'
        format.html { redirect_to(@location) }
        format.xml  { render :xml => @location, :status => :created, :location => @location }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @location.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /locations/1
  # PUT /locations/1.xml
  def update
    @location = Location.find(params[:id])

    respond_to do |format|
      if @location.update_attributes(params[:location])
        flash[:notice] = 'Location was successfully updated.'
        format.html { redirect_to(@location) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @location.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /locations/1
  # DELETE /locations/1.xml
  def destroy
    @location = Location.find(params[:id])
    @location.destroy

    respond_to do |format|
      format.html { redirect_to(locations_url) }
      format.xml  { head :ok }
    end
  end
end
