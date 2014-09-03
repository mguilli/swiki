class Wiki < ActiveRecord::Base
  has_many :collabs
  has_many :users, through: :collabs


  def owner
    collabs.where(owner: true).first.user
  end
end
