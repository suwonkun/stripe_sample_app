namespace :stripe do
  desc 'Capture all uncaptured payment intents for a specific connected account'
  task capture_payment_intents: :environment do
    stripe_account_id = 'acct_1NaZA32fQhK2eMWA' # IDはDBから取得するようにする

    Stripe::PaymentIntent.list({ limit: 100 }, stripe_account: stripe_account_id).auto_paging_each do |payment_intent|
      if payment_intent.status == 'requires_capture'
        begin
          # 未キャプチャの支払いをキャプチャします
          captured_payment_intent = Stripe::PaymentIntent.capture(payment_intent.id, {}, stripe_account: stripe_account_id)
          puts "Successfully captured PaymentIntent #{captured_payment_intent.id} with amount #{captured_payment_intent.amount / 100.0}"
        rescue Stripe::StripeError => e
          puts "Failed to capture PaymentIntent #{payment_intent.id}: #{e.message}"
        end
      end
    end
  end
end