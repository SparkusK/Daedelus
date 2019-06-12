require 'rails_helper'

RSpec.describe DataManipulation::DebtorPaymentsController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # DebtorPayment. As you add validations to DebtorPayment, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # DebtorPaymentsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #index" do
    it "returns a success response" do
      DebtorPayment.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      debtor_payment = DebtorPayment.create! valid_attributes
      get :show, params: {id: debtor_payment.to_param}, session: valid_session
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
      debtor_payment = DebtorPayment.create! valid_attributes
      get :edit, params: {id: debtor_payment.to_param}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new DebtorPayment" do
        expect {
          post :create, params: {debtor_payment: valid_attributes}, session: valid_session
        }.to change(DebtorPayment, :count).by(1)
      end

      it "redirects to the created debtor_payment" do
        post :create, params: {debtor_payment: valid_attributes}, session: valid_session
        expect(response).to redirect_to(DebtorPayment.last)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: {debtor_payment: invalid_attributes}, session: valid_session
        expect(response).to be_successful
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested debtor_payment" do
        debtor_payment = DebtorPayment.create! valid_attributes
        put :update, params: {id: debtor_payment.to_param, debtor_payment: new_attributes}, session: valid_session
        debtor_payment.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the debtor_payment" do
        debtor_payment = DebtorPayment.create! valid_attributes
        put :update, params: {id: debtor_payment.to_param, debtor_payment: valid_attributes}, session: valid_session
        expect(response).to redirect_to(debtor_payment)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)" do
        debtor_payment = DebtorPayment.create! valid_attributes
        put :update, params: {id: debtor_payment.to_param, debtor_payment: invalid_attributes}, session: valid_session
        expect(response).to be_successful
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested debtor_payment" do
      debtor_payment = DebtorPayment.create! valid_attributes
      expect {
        delete :destroy, params: {id: debtor_payment.to_param}, session: valid_session
      }.to change(DebtorPayment, :count).by(-1)
    end

    it "redirects to the debtor_payments list" do
      debtor_payment = DebtorPayment.create! valid_attributes
      delete :destroy, params: {id: debtor_payment.to_param}, session: valid_session
      expect(response).to redirect_to(debtor_payments_url)
    end
  end

end
