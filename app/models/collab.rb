class Collab < ActiveRecord::Base
  belongs_to :user
  belongs_to :wiki

  def index
    
  end
end
