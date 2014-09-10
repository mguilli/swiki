class ChargePolicy < Struct.new(:user, :charge)

  def new?
    user.present? && user.role?(:free)
  end

  def create?
    new?
  end
end