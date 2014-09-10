class Wiki < ActiveRecord::Base
  has_many :collabs, dependent: :destroy
  has_many :users, through: :collabs
  has_one :owner_collab, -> {where("owner = ?", true)}, class_name: "Collab"
  has_one :owner, through: :owner_collab, source: :user

  after_update :remove_collabs, if: :public_wiki?

  extend FriendlyId
  friendly_id :title, use: :slugged

  scope :grouped_collabs, -> { joins(:collabs).group("collabs.wiki_id")}

  scope :by_user_collabs, -> (id){
    Wiki.joins(:collabs).where("collabs.user_id = ?",id).where("collabs.owner = ?", false)
  }

  scope :by_user_wikis, -> (id){
    Wiki.joins(:collabs).where("collabs.user_id = ?", id).where("collabs.owner = ?", true)
  }

  def remove_collabs
    self.collabs.where(owner: false).delete_all
  end

  def public_wiki?
    self.public == true
  end

  def self.create_wiki_seed(user, title, public = true)
    newwiki = Wiki.new(
      title: title,
      body: "This is a #{title} article.",
      public: public
    )
    newwiki.save

    newcollab = Collab.new(
      user_id: user.id,
      wiki_id: newwiki.id,
      owner: true
    )
    newcollab.save  
  end
end
