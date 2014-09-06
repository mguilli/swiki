class CollabsController < ApplicationController
  before_action :authenticate_user!

  def index
    @wiki = Wiki.find(params[:id])
    @owner = User.joins(:collabs).where("collabs.wiki_id = ?", @wiki.id).where("collabs.owner = ?", true).first
    @current = User.joins(:collabs).where("collabs.wiki_id = ?", @wiki.id).where("collabs.owner = ?", false)
    @available = User.where.not(id: @owner.id) - @current.to_a

  end
end
