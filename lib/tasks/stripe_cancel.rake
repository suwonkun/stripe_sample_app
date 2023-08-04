namespace :stripe do
  desc 'Cancel a specific uncaptured payment intent for a specific connected account'
  task cancel_specific_uncaptured_payment_intent: :environment do
    begin
      stripe_account_id = 'acct_1NaZA32fQhK2eMWA' # ストライプのアカウントIDを指定します
      payment_intent_id = 'pi_3NbJKQ2fQhK2eMWA0kpSgI5X' # キャンセルする支払いのIDを指定します（DBから取得するようにする）

      payment_intent = Stripe::PaymentIntent.cancel(payment_intent_id, {}, stripe_account: stripe_account_id)
      puts "Successfully cancelled PaymentIntent #{payment_intent.id}"
    rescue Stripe::StripeError => e
      puts "Failed to cancel PaymentIntent #{payment_intent_id}: #{e.message}"
    end
  end
end