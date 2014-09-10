class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    true
  end

  def show?
    record.public || user.role?(:admin) || (user.present? && (record.collabs.where(user_id: user.id).present?))
  end

  def create?
    user.present?
  end

  def new?
    create?
  end

  def update?
    show?
  end

  def edit?
    update?
  end

  def destroy?
    user.role?(:admin)
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user.present? && user.role?(:admin)
        scope.includes(:owner).load
      else
        scope.where(public: true)
      end
    end
  end
end

