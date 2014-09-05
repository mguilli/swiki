class Wiki < ActiveRecord::Base
  has_many :collabs
  has_many :users, through: :collabs


  def owner
    collabs.where(owner: true).first.user
  end

  def self.create_wiki(user, title, public = true)
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
