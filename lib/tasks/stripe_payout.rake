require 'stripe'

namespace :stripe do
  desc 'Create a Stripe Payout'
  task create_payout: :environment do
    Stripe.api_key = Rails.application.credentials.dig(:stripe, :secret_key) # Use the API key from the Rails credentials
    require 'stripe'

    # Stripeのアカウントの残高を取得します
    balance = Stripe::Balance.retrieve({stripe_account: 'acct_1NaZA32fQhK2eMWA'}) #DBから取得するようにする

    Stripe::Payout.create({
      # 連結アカウントの全額を出金します
      amount: balance.available.detect { |balance| balance.currency == 'jpy' }.amount,
      currency: 'jpy',
    },
    { stripe_account: 'acct_1NaZA32fQhK2eMWA' }  #DBから取得するようにする
    )
  end
end