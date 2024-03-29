class WikisController < ApplicationController
  before_action :set_wiki, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]
  after_action :verify_authorized, except: :index
  # after_action :verify_policy_scoped, only: :index


  def index
    case params[:option]
    when "mine"
      authenticate_user!
      @my_wikis = Wiki.by_user_wikis(current_user.id)
      @collab_wikis = Wiki.by_user_collabs(current_user.id)
      render "my_wiki"
    else
      # Wiki.all for admin, Wiki.where(public: true) for all others
      @wikis = policy_scope(Wiki) 
      # @wikis = Wiki.where(public: true)
      @collabs_count = Wiki.grouped_collabs.count
    end
  end

  def show
    authorize @wiki
  end

  def new
    @wiki = Wiki.new
    authorize @wiki
    @switch = "new"
  end

  def edit
    authorize @wiki
    @switch = "edit"
  end

  def create
    @wiki = Wiki.new(wiki_params)
    authorize @wiki
    @collab = @wiki.collabs.build(
      owner: true,
      user_id: current_user.id
    )

    if @wiki.save #&& @collab.save
      redirect_to @wiki, notice: 'Wiki was successfully created.'
    else
      render action: 'new' 
    end
  end

  def update
    authorize @wiki
    if @wiki.update(wiki_params)
      case params[:option]
      when "fromlink"
        redirect_to :back
      else
        redirect_to @wiki, notice: 'Wiki was successfully updated.'
      end
    else
      render action: 'edit'
    end
  end

  def destroy
    authorize @wiki
    @wiki.destroy
    respond_to do |format|
      format.html { redirect_to wikis_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_wiki
      @wiki = Wiki.friendly.find(params[:id])

      rescue ActiveRecord::RecordNotFound
        flash[:error] = "Record not found."
        redirect_to root_path 
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def wiki_params
      params.require(:wiki).permit(:title, :body, :public)
    end
end
