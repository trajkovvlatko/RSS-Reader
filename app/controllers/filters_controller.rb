class FiltersController < ApplicationController
  
  layout "template"
  
  # GET /filters
  # GET /filters.xml
  def index
    if session[:user_id]
      subs = Subscription.all(:conditions => ["user_id = ?", session[:user_id]])
      
      @filters = Array.new
      
      subs.each do |s|
        filter = Filter.all(:conditions => ["subscription_id = ?", s.id])
        filter.each do |f|
          @filters.push f
        end
      end
      
      #@filters = Filter.all
      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @filters }
      end
    else
      redirect_to "/login"
    end
  end

  # GET /filters/1
  # GET /filters/1.xml
  def show
    if session[:user_id]
      @filter = Filter.find(params[:id])
      sub = Subscription.find(@filter.subscription_id)
      @s = sub.title
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @filter }
      end
    else
      redirect_to "/login"
    end
  end

  # GET /filters/new
  # GET /filters/new.xml
  def new
    if session[:user_id]
      @filter = Filter.new
      @subscriptions = Subscription.all(:conditions => ["user_id = ?", session[:user_id]])
      respond_to do |format|
        format.html # new.html.erb
        format.xml  { render :xml => @filter }
      end
    else
      redirect_to "/login"
    end
  end

  # GET /filters/1/edit
  def edit
    if session[:user_id]
      @filter = Filter.find(params[:id])
      @subscriptions = Subscription.all(:conditions => ["user_id = ?", session[:user_id]])
    else
      redirect_to "/login"
    end
  end

  # POST /filters
  # POST /filters.xml
  def create
    if session[:user_id]
      sub = Subscription.find(params[:filter][:subscription_id]).first
      
      @filter = Filter.new
      @filter.name = params[:filter][:name]
      @filter.subscription_id = sub.id
      
      respond_to do |format|
        if @filter.save
          format.html { redirect_to(@filter, :notice => 'Filter was successfully created.') }
          format.xml  { render :xml => @filter, :status => :created, :location => @filter }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @filter.errors, :status => :unprocessable_entity }
        end
      end
    else
      redirect_to "/login"
    end
  end

  # PUT /filters/1
  # PUT /filters/1.xml
  def update
    if session[:user_id]
      @filter = Filter.find(params[:id])
  
      respond_to do |format|
        if @filter.update_attributes(params[:filter])
          format.html { redirect_to(@filter, :notice => 'Filter was successfully updated.') }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @filter.errors, :status => :unprocessable_entity }
        end
      end
    else
      redirect_to "/login"
    end
  end

  # DELETE /filters/1
  # DELETE /filters/1.xml
  def destroy
    if session[:user_id]
      @filter = Filter.find(params[:id])
      @filter.destroy
  
      respond_to do |format|
        format.html { redirect_to(filters_url) }
        format.xml  { head :ok }
      end
    else
      redirect_to "/login"
    end
  end
end
