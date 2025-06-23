# spec/requests/users_follow_spec.rb
require 'rails_helper'

RSpec.describe "Users::Follow", type: :request do
  let(:user)       { create(:user) }
  let(:other_user) { create(:user) }

  describe "POST /users/:id/follow" do
    context "when unauthenticated" do
      it "redirects to login" do
        post follow_user_path(other_user, format: :turbo_stream)
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when authenticated" do
      before { sign_in user }

      it "follows the user and responds OK to turbo-stream" do
        expect {
          post follow_user_path(other_user, format: :turbo_stream)
        }.to change { other_user.reload.followers_count }.by(1)

        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "DELETE /users/:id/follow" do
    before { user.follow(other_user) }

    context "when unauthenticated" do
      it "redirects to login" do
        delete follow_user_path(other_user, format: :turbo_stream)
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when authenticated" do
      before { sign_in user }

      it "unfollows the user and responds OK to turbo-stream" do
        expect {
          delete follow_user_path(other_user, format: :turbo_stream)
        }.to change { other_user.reload.followers_count }.by(-1)

        expect(response).to have_http_status(:success)
      end
    end
  end
end
