class MoviesController < ApplicationController
   

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    config.logger = Logger.new(STDOUT)
    config.log_level = :debug # In any environment initializer, or
    
    get_ratings()
    logger.debug "RATINGS ARE #{@sel_ratings}"
    logger.debug "Columns....#{params[:column]}"
    
    @all_ratings = Movie.find(:all, :select => "distinct rating",).map(&:rating)
    @movies = Movie.find_all_by_rating(@sel_ratings, :order=>params[:column])
    @highlight = ''
    if params[:column]!= nil
      @highlight = params[:column]
    end
  end
  
  def get_ratings
    @sel_rating_params = ""
    if !defined? @sel_ratings
      logger.debug("INSTANTIATING @SEL_RATINGS FOR THE FIRST TIME!")
      @sel_ratings= []
    end
    if params[:ratings] != nil
      @sel_ratings = params[:ratings].keys
      @sel_ratings.each do |rating| 
          @sel_rating_params += "&ratings[#{rating}]=1"
      end
      logger.debug("HERE ARE THE RATINGS PARAM FOR THE VIEW: #{@sel_rating_params}")
    end
  end
  
  def sort
    @movies = Movie.find(:all, :order => "title")
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
