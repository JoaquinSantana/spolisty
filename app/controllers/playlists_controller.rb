class PlaylistsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_user, only: [:index, :show, :destroy]
  before_action :find_playlist, only: [:show, :destroy]

  respond_to :html

  def index
    @playlists = @user.playlists.includes(:tracks)
    #redirect_to current_user
  end

  def show
    if params[:track]
      @tracks = @playlist.tracks.includes(:artist, :album).where(id: params[:track]).paginate(page: params[:page], per_page: 50)
      session[:back_to_playlist] = true
    else
      session[:back_to_playlist] = false if session[:back_to_playlist]
      @tracks = @playlist.tracks.includes(:artist, :album).paginate(page: params[:page], per_page: 50)
    end
    @reviews = @playlist.reviews.includes(:user).order("created_at DESC")

    if @reviews.blank?
      @average_rating = 0
    else
      @average_rating = @reviews.average(:rating).round(2)
    end
  end

  def destroy 
    if current_user == @playlist.user && !@playlist.special
      @playlist.destroy
      flash[:success] = t('main_site.playlists.destroy')
    else
      flash[:error] = t('main_site.playlists.cantdestroy') 
    end
    redirect_to @user
  end

  def import
    current_user.import_playlist
    current_user.update_columns(last_download_playlists: Time.now)
    flash[:success] = t('main_site.playlists.import')
    redirect_to current_user
  end

  def export
    playlist = Playlist.find(params[:id])
    if current_user == playlist.user
      playlist.upload_tracks
    end
    redirect_to :back
    flash[:success] = t('main_site.playlists.export')
  end

  def best
    @playlists = Playlist.best_playlists.limit(20)
  end


  private

  def find_playlist
    @playlist = @user.playlists.find(params[:id])
  end

  def find_user
    @user = User.find(params[:user_id])
  end
end
