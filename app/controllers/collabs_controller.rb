class CollabsController < ApplicationController
  before_action :authenticate_user!

  def index
    @wiki = Wiki.find(params[:wiki_id])
    @owner = User.owner_by_wiki(@wiki.id)
    @current = User.current_collaborators(@wiki.id)
    @available = User.where.not(id: @owner.id) - @current.to_a
  end

  def new
    @collab = Collab.new
  end
  
  def create
    @wiki = Wiki.find(params[:wiki_id])
    @collab = Collab.new(collab_params)

    if @collab.save
      redirect_to wiki_collabs_path, notice: 'Collaborator successfully added.'
    else
      redirect_to wiki_collabs_path, notice: 'Error adding collaborator.'
    end
  end

  def destroy
    @collab = Collab.find(params[:id])

    if @collab.destroy
      redirect_to wiki_collabs_path, notice: 'Collaborator successfully removed.'
    else
      redirect_to wiki_collabs_path, notice: 'Error removing collaborator.'
    end
  end

  private

  def collab_params
    params.require(:collab).permit(:owner, :user_id, :wiki_id)
  end
end
