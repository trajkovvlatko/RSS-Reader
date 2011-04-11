class SubscriptionsController < ApplicationController
  
  layout "template"
  
  require 'rss/1.0'
  require 'rss/2.0'
  require 'open-uri'
  
  # GET /subscriptions
  # GET /subscriptions.xml
  def index
    if session[:user_id] 
      @subscriptions = Subscription.all(:conditions => ["user_id = ?", session[:user_id]])
      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @subscriptions }
      end
    else
      redirect_to "/login"
    end
  end

  # GET /subscriptions/1
  # GET /subscriptions/1.xml
  def show
    if session[:user_id] 
      @subscription = Subscription.find(params[:id])
  
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @subscription }
      end
    end
  end

  # GET /subscriptions/new
  # GET /subscriptions/new.xml
  def new
    if session[:user_id] 
      @subscription = Subscription.new
      respond_to do |format|
        format.html # new.html.erb
        format.xml  { render :xml => @subscription }
      end
    end
  end

  # GET /subscriptions/1/edit
  def edit
    if session[:user_id] 
      @subscription = Subscription.find(params[:id])
    end
  end

  # POST /subscriptions
  # POST /subscriptions.xml
  def create
    if session[:user_id] 
      user = User.find(session[:user_id])
      s = Subscription.new
      s.url = params[:subscription][:url]
      s.title = params[:subscription][:title]
      s.user = user
      @subscription = s
  
      respond_to do |format|
        if @subscription.save
          format.html { redirect_to(@subscription, :notice => 'Subscription was successfully created.') }
          format.xml  { render :xml => @subscription, :status => :created, :location => @subscription }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @subscription.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # PUT /subscriptions/1
  # PUT /subscriptions/1.xml
  def update
    if session[:user_id] 
      @subscription = Subscription.find(params[:id])
  
      respond_to do |format|
        if @subscription.update_attributes(params[:subscription])
          format.html { redirect_to(@subscription, :notice => 'Subscription was successfully updated.') }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @subscription.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /subscriptions/1
  # DELETE /subscriptions/1.xml
  def destroy
    if session[:user_id] 
      @subscription = Subscription.find(params[:id])
      @subscription.destroy
  
      respond_to do |format|
        format.html { redirect_to(subscriptions_url) }
        format.xml  { head :ok }
      end
    end
  end
  
  def read
    if session[:user_id] 
      
      @subscription = Subscription.find(params[:id], :conditions => ["user_id = ?", session[:user_id]])
      @filters = Filter.all(:conditions => ["subscription_id = ?", @subscription.id])
      
      @arrFilter = Array.new
      @filters.each do |f|
        @arrFilter.push f.name
      end  
      source = @subscription.url
      content = ""
      open(source) do |s| 
        content = s.read 
      end
      @rss = RSS::Parser.parse(content, false)
      @arrPosts = Array.new
      if @arrFilter.size > 0
  		  @rss.items.each do |item|
          @arrFilter.each do |filter|
    			  if item.description.include?(filter)
    				  @arrPosts.push [item.title, item.link, item.description]
    			  else
    				
    			  end
    			end
  		  end
  	  else
  	 	   @rss.items.each do |item|
    			 @arrPosts.push [item.title, item.link, item.description]
    		 end
	    end
	  
      @arrPosts.uniq!
      
      @link = Array.new
      @rss.items.each do |item|
        #logger.info item.description
      	if !@rss.channel.description.nil?
      	  s = @rss.channel.description.include?("reddit")
      	  if s 
      	    images = item.description.scan(/href=".*?"/i)
      	    images.each do |image|
      	      if image.include?("png") || image.include?("jpg") || image.include?("gif") 
            		image = image.gsub("href=", "")
            		image = image.gsub('"', "")
            		@link.push(Array.new([image, item.title]))
      	      end
      	    end
      	  end
      	end
      end
      
      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @subscriptions }
      end
    end
  end
  
end
