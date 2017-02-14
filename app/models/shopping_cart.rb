class ShoppingCart < ActiveRecord::Base
  belongs_to :campaign

  has_many :items, class_name: 'CartItem', dependent: :destroy

  accepts_nested_attributes_for :items, allow_destroy: true, reject_if: proc { |a| a['quantity'].to_i.zero? }

  mount_uploader :tax_document, SecureDocumentUploader

  attr_accessible :fees, :notes, :subtotal, :taxes, :shipping, :items_attributes,
                  :tax_document, :remove_tax_document

  def calculate_subtotal
    items.sum(&:subtotal)
  end

  def calculate_subtotal!
    self.update_attributes(subtotal: calculate_subtotal)
  end

  def calculate_fees
    ((calculate_subtotal * 1.05) / 5).round * 5 - calculate_subtotal
  end

  def calculate_fees!
    self.update_attributes(fees: calculate_fees)
  end

  def calculate_order_total
    calculate_subtotal + calculate_fees
  end

  def calculate_order_total!
    self.update_attributes(subtotal: calculate_subtotal, fees: calculate_fees)
  end

  def order_total
    subtotal + fees + taxes + shipping
  end
end
