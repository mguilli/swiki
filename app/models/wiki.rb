class Wiki < ActiveRecord::Base
  has_many :users, through: :collabs
end
