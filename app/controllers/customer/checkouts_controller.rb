class Customer::CheckoutsController < ApplicationController
  before_action :authenticate_customer!

  def create
    line_items = current_customer.line_items_checkout
    session = create_session(line_items)
    # Allow redirection to the host that is different to the current host
    redirect_to session.url, allow_other_host: true
  end

  private

  def create_session(line_items)
    # 売上の20%を手数料として設定
    total_amount = line_items.sum do |item|
      item[:quantity] * item[:price_data][:unit_amount]
    end
  
    application_fee = (total_amount * 0.20).to_i

  
    Stripe::Checkout::Session.create({
      client_reference_id: current_customer.id,
      customer_email: current_customer.email,
      mode: 'payment',
      payment_method_types: ['card'],
      line_items: line_items,
      shipping_address_collection: {
        allowed_countries: ['JP']
      },
      shipping_options: [
        {
          shipping_rate_data: {
            type: 'fixed_amount',
            fixed_amount: {
              amount: POSTAGE,
              currency: 'jpy'
            },
            display_name: '全国一律'
          }
        }
      ],
      payment_intent_data: {
        capture_method: 'manual', #未キャプチャの支払いを作成
        application_fee_amount: application_fee, # 手数料を設定
      },
      success_url: "#{root_url}orders/success",
      cancel_url: "#{root_url}cart_items"
    },
    {
      stripe_account: 'acct_1NaZA32fQhK2eMWA'  # Stripeの連結アカウントIDを指定します
    })
  end
end
