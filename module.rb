module Purchasable                                                                                                                                                    def purchase
    result = Braintree::Transaction.sale(amount: total, credit_card: card)
    if result.success?
      self.purchased_at = Time.zone.now
      save!
    end
 end
end

module Purchasable
  def purchase(total, card)
    result = Braintree::Transaction.sale(amount: total, credit_card: card)
    result.success? # leave it up to the caller to mark as purchased
  end
end
