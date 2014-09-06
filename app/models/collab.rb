class Collab < ActiveRecord::Base
  belongs_to :user
  belongs_to :wiki

  def self.collab_id(wiki, user)
    Collab.where(wiki_id: wiki.id).where(user_id: user.id).first.id    
  end

end
