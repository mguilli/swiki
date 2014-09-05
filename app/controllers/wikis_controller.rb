class WikisController < ApplicationController
  before_action :set_wiki, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]

  def index
    case params[:filter]
    when "mine"
      @my_wikis = Wiki.by_user_wikis(current_user.id)
      @collab_wikis = Wiki.by_user_collabs(current_user.id)
      render "my_wiki"
    else
      @wikis = Wiki.where(public: true)
    end
  end

  def show
  end

  def new
    @wiki = Wiki.new
  end

  def edit
  end

  def create
    @wiki = Wiki.new(wiki_params)
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
    respond_to do |format|
      if @wiki.update(wiki_params)
        format.html { redirect_to @wiki, notice: 'Wiki was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @wiki.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @wiki.destroy
    respond_to do |format|
      format.html { redirect_to wikis_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_wiki
      @wiki = Wiki.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def wiki_params
      params.require(:wiki).permit(:title, :body, :public)
    end
end
