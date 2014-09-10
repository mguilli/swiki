class CollabsController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized, except: :index
  # after_action :verify_policy_scoped, only: :index


  def index
    @wiki = Wiki.friendly.find(params[:wiki_id])
    authorize @wiki, :show_collabs?
    @owner = User.owner_by_wiki(@wiki.id)
    @current = User.current_collaborators(@wiki.id)
    @available = User.where.not(id: @owner.id) - @current.to_a
  end

  def create
    @wiki = Wiki.friendly.find(params[:wiki_id])
    authorize @wiki, :collab_add_remove?
    @collab = Collab.new(collab_params)
    authorize @collab

    if @collab.save
      redirect_to wiki_collabs_path, notice: 'Collaborator successfully added.'
    else
      redirect_to wiki_collabs_path, notice: 'Error adding collaborator.'
    end
  end

  def destroy
    @wiki = Wiki.friendly.find(params[:wiki_id])
    authorize @wiki, :collab_add_remove?

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
