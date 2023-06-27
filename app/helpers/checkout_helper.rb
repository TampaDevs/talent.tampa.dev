module CheckoutHelper
  def new_checkout_path(user:, success_path:, plan: "full_time")
    BusinessSubscriptionCheckout.new(
      user: user,
      plan: plan,
      success_path: success_path
    ).url
  end

  def checkout_flow_start!
    session[:checkout_continue] = true
  end

  def checkout_flow_continue?
    session[:checkout_continue]
  end

  def checkout_flow_completed!
    session.delete(:checkout_continue)
  end
end
