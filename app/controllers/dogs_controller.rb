class DogsController < ApplicationController
  before_action :set_dog, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!,only: [:edit,:update,:destroy,:new]
  add_breadcrumb 'Home', 'http://inuerabi-mannnakakunn.sqale.jp/dogs/'
  

  def mypage
    @user = User.find(params[:id])
    @bookmark=Bookmark.all
    @dog=Dog.all
    @tags = Dog.tag_counts_on(:tags).order('count DESC')
  end
  
  def rank
    @dogs = Dog.all.order("popularity")
  end

  def today
    @dogs = Dog.all.order("popularity")
  end

  def week
    @dogs = Dog.all.order("popularity")
  end
  
  def month
    @dogs = Dog.all.order("popularity")
  end

  def year
    @search = Dog.search(params[:q])
    @model = @search.result.paginate(:page => params[:page], :per_page => 28)
    # @models = @model.tagged_with(params[:name])
    @models = @search.result.paginate(:page => params[:page], :per_page => 28).order("fav DESC")
    @models_year = @search.result.where(post_date: 5.days.ago).paginate(:page => params[:page], :per_page => 28).order("fav DESC")
    # ransackのクエリとpagenate用の記述を連ねる。検索結果に対してページネートする。
    # @dogs = Dog.all
    @tags = Dog.tag_counts_on(:tags).order('count DESC')
  end

  def choice
  end

  def tag
    @search = Dog.search(params[:q])
    @model = @search.result.paginate(:page => params[:page], :per_page => 20)
    @models = @model.tagged_with(params[:name]).order("fav DESC")
    @models_year = @search.result.where(post_date: 365.day.ago.beginning_of_day..1.day.ago.beginning_of_day).paginate(:page => params[:page], :per_page => 20).order("fav DESC")
    @models_month = @search.result.where(post_date: 31.day.ago.beginning_of_day..1.day.ago.beginning_of_day).paginate(:page => params[:page], :per_page => 20).order("fav DESC")
    @models_week = @search.result.where(post_date: 7.day.ago.beginning_of_day..1.day.ago.beginning_of_day).paginate(:page => params[:page], :per_page => 20).order("fav DESC")
    @models_today = @search.result.where(post_date: 3.day.ago.beginning_of_day..1.day.ago.beginning_of_day).paginate(:page => params[:page], :per_page => 20).order("fav DESC")
    @tags = Dog.tag_counts_on(:tags)
    render 'index'
  end

  def flickr_search
    word=Dog.find(params[:id]).en_name
    FlickRaw.api_key       = "bac0a9ba36efc0acc5d281d871d431be"
    FlickRaw.shared_secret = "a0454904da11ff02"
    flickr.access_token    = "72157660870752747-c07c9edd87e7fcff"
    flickr.access_secret   = "850a21b8b8b0c59e"
    flickr.test.login

    @photos = flickr.photos.search(text: word, license:"4,5,6" ,sort: "relevance" ,per_page: 20)
    #そもそもデータが受け取れているか確認
    logger.warn("number of photos from flickr: #{@photos.count}")
  end

  # GET /dogs
  # GET /dogs.json
  def index
    @search = Dog.search(params[:q])
    @model = @search.result.paginate(:page => params[:page], :per_page => 20)
    # @models = @model.tagged_with(params[:name])
    @models = @search.result.paginate(:page => params[:page], :per_page => 20).order("fav DESC")
    @models_year = @search.result.where(post_date: 365.day.ago.beginning_of_day..1.day.ago.beginning_of_day).paginate(:page => params[:page], :per_page => 40).order("fav DESC")
    @models_month = @search.result.where(post_date: 31.day.ago.beginning_of_day..1.day.ago.beginning_of_day).paginate(:page => params[:page], :per_page => 20).order("fav DESC")
    @models_week = @search.result.where(post_date: 15.day.ago.beginning_of_day..1.day.ago.beginning_of_day).paginate(:page => params[:page], :per_page => 20).order("fav DESC").limit(4)
    @models_today = @search.result.where(post_date: 3.day.ago.beginning_of_day..1.day.ago.beginning_of_day).paginate(:page => params[:page], :per_page => 20).order("fav DESC")
   
    # ransackのクエリとpagenate用の記述を連ねる。検索結果に対してページネートする。
    # @dogs = Dog.all
    @tags = Dog.tag_counts_on(:tags).order('count DESC')
  end

  def tag_cloud
    # order('count DESC')でカウントの多い順にタグを並べています
    @tags = Dog.tag_counts_on(:tags).order('count DESC')
  end

  # GET /dogs/1
  # GET /dogs/1.json
  def show
    @dog_title = Dog.find(params[:id]).title
    @dog_url = Dog.find(params[:id]).url.match(/\?([^&]+)/).to_s.sub("?v=","")
    @recommended = Dog.where.not(id: params[:id] ,genre: Dog.find(params[:id]).genre).order('fav DESC').limit(21)
    recommended = Dog.where.not(id: params[:id]).order('fav DESC')
    @related = recommended.where(genre: Dog.find(params[:id]).genre).order('fav DESC').limit(7)
    @tags = Dog.tag_counts_on(:tags).order('count DESC')
    @dog_tag = Dog.find(params[:id]).tag_list
    add_breadcrumb 'いぬいぬ動画',:dogs_path
    add_breadcrumb @dog_title, :dog_path
  end

  # GET /dogs/new
  def new
    @dog = Dog.new
  end

  # GET /dogs/1/edit
  def edit
  end

  # POST /dogs
  # POST /dogs.json
  def create
    @dog = Dog.new(dog_params)

    respond_to do |format|
      if @dog.save
        format.html { redirect_to @dog, notice: 'Dog was successfully created.' }
        format.json { render action: 'show', status: :created, location: @dog }
      else
        format.html { render action: 'new' }
        format.json { render json: @dog.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /dogs/1
  # PATCH/PUT /dogs/1.json
  def update
    respond_to do |format|
      if @dog.update(dog_params)
        format.html { redirect_to @dog, notice: 'Dog was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @dog.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dogs/1
  # DELETE /dogs/1.json
  def destroy
    @dog.destroy
    respond_to do |format|
      format.html { redirect_to dogs_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dog
      @dog = Dog.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def dog_params
      params.require(:dog).permit(:name, :en_name, :size, :group, :color, :price, :popularity, :maintext, :image, :care, :care_point, :personality, :personality_point, :momentum, :momentum_point, :feature, :disease, :discipline, :life, :environment, :sociability, :dog_sociability, :person_sociability, :cold_point, :hot_point, :watchdog_point, :country, :origin, :tag_list, :tag_name)
    end
end
