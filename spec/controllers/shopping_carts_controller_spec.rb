require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe ShoppingCartsController do
  let!(:user) { login Fabricate(:user) }
  let!(:campaign) { Fabricate(:campaign, creator: user, status: 'draft') }

  # This should return the minimal set of attributes required to create a valid
  # ShoppingCart. As you add validations to ShoppingCart, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { } }

  describe "GET show" do
    let(:shopping_cart) { campaign.shopping_cart }

    before { get :show, { :id => shopping_cart.to_param} }

    specify { assigns(:shopping_cart).should eq(shopping_cart) }
  end

  describe "GET edit" do
    let(:shopping_cart) { campaign.shopping_cart }

    before { get :edit, { :id => shopping_cart.to_param } }

    specify { assigns(:shopping_cart).should eq(shopping_cart) }
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested shopping_cart" do
        shopping_cart = campaign.shopping_cart
        # Assuming there are no other shopping_carts in the database, this
        # specifies that the ShoppingCart created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        ShoppingCart.any_instance.should_receive(:update_attributes).with({ "subtotal" => "" })
        put :update, { :id => shopping_cart.to_param, :shopping_cart => { "subtotal" => "" }}
      end

      it "assigns the requested shopping_cart as @shopping_cart" do
        shopping_cart = campaign.shopping_cart
        put :update, { :id => shopping_cart.to_param, :shopping_cart => valid_attributes}
        assigns(:shopping_cart).should eq(shopping_cart)
      end

      it "redirects to the shopping_cart" do
        shopping_cart = campaign.shopping_cart
        put :update, { :id => shopping_cart.to_param, :shopping_cart => valid_attributes}
        response.should redirect_to(shopping_cart)
      end
    end

    describe "with invalid params" do
      it "assigns the shopping_cart as @shopping_cart" do
        shopping_cart = campaign.shopping_cart
        # Trigger the behavior that occurs when invalid params are submitted
        ShoppingCart.any_instance.stub(:save).and_return(false)
        put :update, { :id => shopping_cart.to_param, :shopping_cart => { "subtotal" => "invalid value" }}
        assigns(:shopping_cart).should eq(shopping_cart)
      end

      it "re-renders the 'edit' template" do
        shopping_cart = campaign.shopping_cart
        # Trigger the behavior that occurs when invalid params are submitted
        ShoppingCart.any_instance.stub(:save).and_return(false)
        put :update, { :id => shopping_cart.to_param, :shopping_cart => { "subtotal" => "invalid value" }}
        response.should render_template("edit")
      end
    end
  end

end
