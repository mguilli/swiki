class WikiPolicy < ApplicationPolicy

  def collab_add_remove?
    make_private_edit? && (record.public == false)
  end

  def make_private_new?
    (user.role?(:admin) || user.role?(:premium)) 
  end

  def make_private_edit?
    (user.role?(:admin) || user.role?(:premium)) && (User.owner_by_wiki(record.id) == user)
  end

  def show_collabs?
    (user.role?(:admin) || (record.collabs.where(user_id: user.id).present?)) && (record.public == false)
  end

end