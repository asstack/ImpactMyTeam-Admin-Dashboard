class ShoppingCartsController < ApplicationController
  before_filter :authenticate_user!

  load_and_authorize_resource

  # GET /shopping_carts/1
  # GET /shopping_carts/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @shopping_cart }
    end
  end

  # GET /shopping_carts/1/edit
  def edit
  end

  # PUT /shopping_carts/1
  # PUT /shopping_carts/1.json
  def update
    respond_to do |format|
      if @shopping_cart.update_attributes(params[:shopping_cart])
        format.html { redirect_to @shopping_cart, notice: 'Shopping cart was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @shopping_cart.errors, status: :unprocessable_entity }
      end
    end
  end
end
