class WikiPolicy < ApplicationPolicy

  def make_private_new?
    (user.role?(:admin) || user.role?(:premium)) #&& (User.owner_by_wiki(record.id) == user)
  end

  def make_private_edit?
    (user.role?(:admin) || user.role?(:premium)) && (User.owner_by_wiki(record.id) == user)
  end

end