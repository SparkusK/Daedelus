require 'rails_helper'

RSpec.describe DataManipulation::CustomersController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Customer. As you add validations to Customer, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # CustomersController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #index" do
    it "returns a success response" do
      Customer.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      customer = Customer.create! valid_attributes
      get :show, params: {id: customer.to_param}, session: valid_session
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
      customer = Customer.create! valid_attributes
      get :edit, params: {id: customer.to_param}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Customer" do
        expect {
          post :create, params: {customer: valid_attributes}, session: valid_session
        }.to change(Customer, :count).by(1)
      end

      it "redirects to the created customer" do
        post :create, params: {customer: valid_attributes}, session: valid_session
        expect(response).to redirect_to(Customer.last)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: {customer: invalid_attributes}, session: valid_session
        expect(response).to be_successful
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested customer" do
        customer = Customer.create! valid_attributes
        put :update, params: {id: customer.to_param, customer: new_attributes}, session: valid_session
        customer.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the customer" do
        customer = Customer.create! valid_attributes
        put :update, params: {id: customer.to_param, customer: valid_attributes}, session: valid_session
        expect(response).to redirect_to(customer)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)" do
        customer = Customer.create! valid_attributes
        put :update, params: {id: customer.to_param, customer: invalid_attributes}, session: valid_session
        expect(response).to be_successful
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested customer" do
      customer = Customer.create! valid_attributes
      expect {
        delete :destroy, params: {id: customer.to_param}, session: valid_session
      }.to change(Customer, :count).by(-1)
    end

    it "redirects to the customers list" do
      customer = Customer.create! valid_attributes
      delete :destroy, params: {id: customer.to_param}, session: valid_session
      expect(response).to redirect_to(customers_url)
    end
  end

end
