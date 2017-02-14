class CartItemsController < ApplicationController
  load_and_authorize_resource :shopping_cart

  def create
    authorize! :update, @shopping_cart

    @cart_item = @shopping_cart.items.build(params[:cart_item])

    respond_to do |format|
      if @cart_item.save && @cart_item.calculate_subtotal!
        @shopping_cart.calculate_order_total!
        format.js
      else
        format.js { render 'new' }
      end
    end
  end

  def update
    authorize! :update, @shopping_cart

    @cart_item = @shopping_cart.items.find(params[:id])

    respond_to do |format|
      if @cart_item.update_attributes(params[:cart_item]) && @cart_item.calculate_subtotal!
        @shopping_cart.calculate_order_total!
        format.js
      else
        format.js
      end
    end
  end

  def destroy
    authorize! :update, @shopping_cart

    @cart_item = @shopping_cart.items.find(params[:id])

    respond_to do |format|
      if @cart_item.destroy
        @shopping_cart.calculate_order_total!
        format.js
      else
        format.js { render action: 'update' }
      end
    end
  end
end
