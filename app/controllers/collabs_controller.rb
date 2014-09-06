class CollabsController < ApplicationController
  before_action :authenticate_user!

  def index
    @wiki = Wiki.find(params[:wiki_id])
    @owner = User.owner_by_wiki(@wiki.id)
    @current = User.current_collaborators(@wiki.id)
    @available = User.where.not(id: @owner.id) - @current.to_a
  end

  def destroy
    @collab = Collab.find(params[:id])

    if @collab.destroy
      redirect_to wiki_collabs_path, notice: 'Collaborator successfully removed.'
    else
      redirect_to wiki_collabs_path, notice: 'Error removing collaborator.'
    end
  end
end
