#Lack of Context
module Purchasable                                                                                                                                                    def purchase
    result = Braintree::Transaction.sale(amount: total, credit_card: card)
    if result.success?
      self.purchased_at = Time.zone.now
      save!
    end
 end
end

class Purchase
  def initialize(order)
    @order = order
  end

  def submit
    result = Braintree::Transaction.sale(amount: @order.total, credit_card: @order.card)
    if result.success?
      @order.mark_as_purchased!
    end
  end
end


#Refactored Version
=begin
module Purchasable
  def purchase(total, card)
    result = Braintree::Transaction.sale(amount: total, credit_card: card)
    result.success? # leave it up to the caller to mark as purchased
  end
end
=end

