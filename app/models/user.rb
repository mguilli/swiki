class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
         
  has_many :collabs, dependent: :destroy       
  has_many :wikis, through: :collabs

  scope :owner_by_wiki, -> (wiki_id){
    User.joins(:collabs).where("collabs.wiki_id = ?", wiki_id).where("collabs.owner = ?", true).first    
  }

  scope :current_collaborators, -> (wiki_id){
    User.joins(:collabs).where("collabs.wiki_id = ?", wiki_id).where("collabs.owner = ?", false)
  }
  
  def role?(base_role)
    role == base_role.to_s
  end

end
