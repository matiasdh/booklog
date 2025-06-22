# spec/requests/users_spec.rb
require 'rails_helper'

RSpec.describe "Users", type: :request do
  let(:user) { create(:user) }

  describe "GET /users/:id" do
    context "when unauthenticated" do
      it "redirects to login" do
        get user_path(user)
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when authenticated" do
      before do
        sign_in user
      end

      it "renders show for authenticated users" do
        get user_path(user)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include(user.username)
      end
    end
  end

  describe "GET /users/:id/edit" do
    context "when unauthenticated" do
      it "redirects to login" do
        get edit_user_path(user)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when authenticated" do
      before do
        sign_in user
      end

      it "renders the edit form" do
        get edit_user_path(user)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("form")
        expect(response.body).to include("value=\"#{user.username}\"")
      end
    end
  end

  describe "PUT /users/:id" do
    let(:valid_attributes)   { { user: { username: "new_user_name" } } }
    let(:invalid_attributes) { { user: { username: "" } } }

    context "when unauthenticated" do
      it "redirects to login" do
        put user_path(user), params: valid_attributes
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when authenticated" do
      before do
        sign_in user
      end

      context "with valid params" do
        it "updates the user and redirects to show" do
          put user_path(user, format: :turbo_stream), params: valid_attributes
          user.reload
          expect(user.username).to eq("new_user_name")
          expect(response.body).to include("<turbo-stream")
          expect(response.body).to include('action="redirect"')
        end
      end

      context "with invalid params" do
        it "does not update and re-renders edit with errors" do
          put user_path(user), params: invalid_attributes
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to include("can&#39;t be blank, is too short (minimum is 3 characters)")
        end
      end
    end
  end
end
