# spec/requests/posts_spec.rb
require 'rails_helper'

RSpec.describe "Users", type: :request do
  let(:user) { create(:user) }

  describe "GET /users/:user_id" do
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

    it "renders index for authenticated users" do
      get user_path(user)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include(user.username)
    end
   end
  end
end
