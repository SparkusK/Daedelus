require 'rails_helper'

RSpec.describe DataManipulation::SectionsController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Section. As you add validations to Section, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # SectionsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #index" do
    it "returns a success response" do
      Section.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      section = Section.create! valid_attributes
      get :show, params: {id: section.to_param}, session: valid_session
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
      section = Section.create! valid_attributes
      get :edit, params: {id: section.to_param}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Section" do
        expect {
          post :create, params: {section: valid_attributes}, session: valid_session
        }.to change(Section, :count).by(1)
      end

      it "redirects to the created section" do
        post :create, params: {section: valid_attributes}, session: valid_session
        expect(response).to redirect_to(Section.last)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: {section: invalid_attributes}, session: valid_session
        expect(response).to be_successful
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested section" do
        section = Section.create! valid_attributes
        put :update, params: {id: section.to_param, section: new_attributes}, session: valid_session
        section.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the section" do
        section = Section.create! valid_attributes
        put :update, params: {id: section.to_param, section: valid_attributes}, session: valid_session
        expect(response).to redirect_to(section)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)" do
        section = Section.create! valid_attributes
        put :update, params: {id: section.to_param, section: invalid_attributes}, session: valid_session
        expect(response).to be_successful
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested section" do
      section = Section.create! valid_attributes
      expect {
        delete :destroy, params: {id: section.to_param}, session: valid_session
      }.to change(Section, :count).by(-1)
    end

    it "redirects to the sections list" do
      section = Section.create! valid_attributes
      delete :destroy, params: {id: section.to_param}, session: valid_session
      expect(response).to redirect_to(sections_url)
    end
  end

end
