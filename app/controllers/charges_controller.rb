class ChargesController < ApplicationController
  after_action :user_to_premium, only: :create

  def create
    
    authorize :charge, :create?
    @amount = params[:amount]

    customer = Stripe::Customer.create(
      email: current_user.email,
      card: params[:stripeToken]
    )

    charge = Stripe::Charge.create(
      customer: customer.id,
      amount: @amount,
      description: "Swiki Premium Membership - #{current_user.email}",
      currency: 'usd'
    )

    flash[:notice] = "Welcome to Swiki Premium Membership, #{current_user.email}!"
    redirect_to root_path

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to root_path
  end

  def new
    authorize :charge, :new?
    @stripe_btn_data = {
      key: "#{ Rails.configuration.stripe[:publishable_key]}",
      description: "Swiki Premium Membership - #{current_user.email}",
      amount: 2_99
    }
  end

  private

  def user_to_premium
    current_user.update_attribute(:role, "premium")    
  end
end
