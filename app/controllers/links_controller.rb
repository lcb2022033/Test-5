class LinksController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :update, :destroy]
  before_action :set_link, only: [:show, :edit, :update, :destroy]
  before_action :allow_editing_link, only: [:edit, :update, :destroy]

  def index
    if current_user
      @links = current_user.links.recent_first if current_user
    else
      @links = Link.recent_first
    end
    @link = Link.new
  end

  def create
    @link = Link.new(link_params)
    @link.user = current_user
    if @link.save
      respond_to do |format|
        format.html { redirect_to root_path }
        format.turbo_stream { render turbo_stream: turbo_stream.prepend("links", @link) }
      end
    else
      index # this is added because index.html needs @links and @link
      render :index, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
  end

  def update
    if @link.update(link_params)
      redirect_to root_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @link.destroy
    redirect_to root_path
    flash[:notice] = "Link was successfully destroyed."
  end

  private

  def link_params
    params.require(:link).permit(:url)
  end

  def allow_editing_link
    redirect_to root_path unless @link.user == current_user
  end
end
