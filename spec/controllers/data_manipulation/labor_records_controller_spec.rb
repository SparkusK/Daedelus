require 'rails_helper'

RSpec.describe DataManipulation::LaborRecordsController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # LaborRecord. As you add validations to LaborRecord, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # LaborRecordsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #index" do
    it "returns a success response" do
      LaborRecord.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      labor_record = LaborRecord.create! valid_attributes
      get :show, params: {id: labor_record.to_param}, session: valid_session
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
      labor_record = LaborRecord.create! valid_attributes
      get :edit, params: {id: labor_record.to_param}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new LaborRecord" do
        expect {
          post :create, params: {labor_record: valid_attributes}, session: valid_session
        }.to change(LaborRecord, :count).by(1)
      end

      it "redirects to the created labor_record" do
        post :create, params: {labor_record: valid_attributes}, session: valid_session
        expect(response).to redirect_to(LaborRecord.last)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: {labor_record: invalid_attributes}, session: valid_session
        expect(response).to be_successful
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested labor_record" do
        labor_record = LaborRecord.create! valid_attributes
        put :update, params: {id: labor_record.to_param, labor_record: new_attributes}, session: valid_session
        labor_record.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the labor_record" do
        labor_record = LaborRecord.create! valid_attributes
        put :update, params: {id: labor_record.to_param, labor_record: valid_attributes}, session: valid_session
        expect(response).to redirect_to(labor_record)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)" do
        labor_record = LaborRecord.create! valid_attributes
        put :update, params: {id: labor_record.to_param, labor_record: invalid_attributes}, session: valid_session
        expect(response).to be_successful
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested labor_record" do
      labor_record = LaborRecord.create! valid_attributes
      expect {
        delete :destroy, params: {id: labor_record.to_param}, session: valid_session
      }.to change(LaborRecord, :count).by(-1)
    end

    it "redirects to the labor_records list" do
      labor_record = LaborRecord.create! valid_attributes
      delete :destroy, params: {id: labor_record.to_param}, session: valid_session
      expect(response).to redirect_to(labor_records_url)
    end
  end

end
