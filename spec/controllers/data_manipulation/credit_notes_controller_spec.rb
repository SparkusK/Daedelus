require 'rails_helper'

RSpec.describe DataManipulation::CreditNotesController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # CreditNote. As you add validations to CreditNote, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # CreditNotesController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #index" do
    it "returns a success response" do
      CreditNote.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      credit_note = CreditNote.create! valid_attributes
      get :show, params: {id: credit_note.to_param}, session: valid_session
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
      credit_note = CreditNote.create! valid_attributes
      get :edit, params: {id: credit_note.to_param}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new CreditNote" do
        expect {
          post :create, params: {credit_note: valid_attributes}, session: valid_session
        }.to change(CreditNote, :count).by(1)
      end

      it "redirects to the created credit_note" do
        post :create, params: {credit_note: valid_attributes}, session: valid_session
        expect(response).to redirect_to(CreditNote.last)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: {credit_note: invalid_attributes}, session: valid_session
        expect(response).to be_successful
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested credit_note" do
        credit_note = CreditNote.create! valid_attributes
        put :update, params: {id: credit_note.to_param, credit_note: new_attributes}, session: valid_session
        credit_note.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the credit_note" do
        credit_note = CreditNote.create! valid_attributes
        put :update, params: {id: credit_note.to_param, credit_note: valid_attributes}, session: valid_session
        expect(response).to redirect_to(credit_note)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)" do
        credit_note = CreditNote.create! valid_attributes
        put :update, params: {id: credit_note.to_param, credit_note: invalid_attributes}, session: valid_session
        expect(response).to be_successful
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested credit_note" do
      credit_note = CreditNote.create! valid_attributes
      expect {
        delete :destroy, params: {id: credit_note.to_param}, session: valid_session
      }.to change(CreditNote, :count).by(-1)
    end

    it "redirects to the credit_notes list" do
      credit_note = CreditNote.create! valid_attributes
      delete :destroy, params: {id: credit_note.to_param}, session: valid_session
      expect(response).to redirect_to(credit_notes_url)
    end
  end

end
