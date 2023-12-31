require 'rails_helper'

RSpec.describe DataManipulation::EmployeesController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Employee. As you add validations to Employee, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # EmployeesController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #index" do
    it "returns a success response" do
      Employee.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      employee = Employee.create! valid_attributes
      get :show, params: {id: employee.to_param}, session: valid_session
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
      employee = Employee.create! valid_attributes
      get :edit, params: {id: employee.to_param}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Employee" do
        expect {
          post :create, params: {employee: valid_attributes}, session: valid_session
        }.to change(Employee, :count).by(1)
      end

      it "redirects to the created employee" do
        post :create, params: {employee: valid_attributes}, session: valid_session
        expect(response).to redirect_to(Employee.last)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: {employee: invalid_attributes}, session: valid_session
        expect(response).to be_successful
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested employee" do
        employee = Employee.create! valid_attributes
        put :update, params: {id: employee.to_param, employee: new_attributes}, session: valid_session
        employee.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the employee" do
        employee = Employee.create! valid_attributes
        put :update, params: {id: employee.to_param, employee: valid_attributes}, session: valid_session
        expect(response).to redirect_to(employee)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)" do
        employee = Employee.create! valid_attributes
        put :update, params: {id: employee.to_param, employee: invalid_attributes}, session: valid_session
        expect(response).to be_successful
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested employee" do
      employee = Employee.create! valid_attributes
      expect {
        delete :destroy, params: {id: employee.to_param}, session: valid_session
      }.to change(Employee, :count).by(-1)
    end

    it "redirects to the employees list" do
      employee = Employee.create! valid_attributes
      delete :destroy, params: {id: employee.to_param}, session: valid_session
      expect(response).to redirect_to(employees_url)
    end
  end

end
