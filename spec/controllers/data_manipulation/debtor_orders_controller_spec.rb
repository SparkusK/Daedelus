require 'rails_helper'

RSpec.describe DataManipulation::DebtorOrdersController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # DebtorOrder. As you add validations to DebtorOrder, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # DebtorOrdersController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #index" do
    it "returns a success response" do
      DebtorOrder.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      debtor_order = DebtorOrder.create! valid_attributes
      get :show, params: {id: debtor_order.to_param}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      debtor_order = DebtorOrder.create! valid_attributes
      get :edit, params: {id: debtor_order.to_param}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new DebtorOrder" do
        expect {
          post :create, params: {debtor_order: valid_attributes}, session: valid_session
        }.to change(DebtorOrder, :count).by(1)
      end

      it "redirects to the created debtor_order" do
        post :create, params: {debtor_order: valid_attributes}, session: valid_session
        expect(response).to redirect_to(DebtorOrder.last)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: {debtor_order: invalid_attributes}, session: valid_session
        expect(response).to be_successful
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested debtor_order" do
        debtor_order = DebtorOrder.create! valid_attributes
        put :update, params: {id: debtor_order.to_param, debtor_order: new_attributes}, session: valid_session
        debtor_order.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the debtor_order" do
        debtor_order = DebtorOrder.create! valid_attributes
        put :update, params: {id: debtor_order.to_param, debtor_order: valid_attributes}, session: valid_session
        expect(response).to redirect_to(debtor_order)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)" do
        debtor_order = DebtorOrder.create! valid_attributes
        put :update, params: {id: debtor_order.to_param, debtor_order: invalid_attributes}, session: valid_session
        expect(response).to be_successful
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested debtor_order" do
      debtor_order = DebtorOrder.create! valid_attributes
      expect {
        delete :destroy, params: {id: debtor_order.to_param}, session: valid_session
      }.to change(DebtorOrder, :count).by(-1)
    end

    it "redirects to the debtor_orders list" do
      debtor_order = DebtorOrder.create! valid_attributes
      delete :destroy, params: {id: debtor_order.to_param}, session: valid_session
      expect(response).to redirect_to(debtor_orders_url)
    end
  end

end
