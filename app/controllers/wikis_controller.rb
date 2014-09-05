class WikisController < ApplicationController
  before_action :set_wiki, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @wikis = Wiki.where(public: true)
  end

  def my_wiki
    @wiki_key = current_user.collabs.where(owner: true).pluck(:wiki_id)
    @my_wikis = Wiki.where(id: [@wiki_key])
    @collab_key = current_user.collabs.where(owner: false).pluck(:wiki_id)
    @collab_wikis = Wiki.where(id: [@collab_key])
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
