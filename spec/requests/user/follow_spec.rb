require "rails_helper"

RSpec.describe "Users::Follow", type: :request do
  let!(:follower) { create(:user) }
  let!(:followed) { create(:user) }

  describe "POST /users/:id/follow" do
    context "when unauthenticated" do
      it "redirects to login" do
        post follow_user_path(followed)
        expect(response).to redirect_to(new_user_session_path)
        expect(response).to have_http_status(:found)
      end
    end

    context "when authenticated" do
      before do
        sign_in follower
      end

      context "when not already following" do
        it "creates a follow relationship" do
          expect {
            post follow_user_path(followed, format: :turbo_stream)
          }.to change { follower.followed_users.count }.by(1)

          expect(follower.followed_users).to include(followed)
        end
      end

      context "when already following" do
        before do
          follower.follow(followed)
        end

        it "does not create a duplicate follow" do
          expect {
            post follow_user_path(followed, format: :turbo_stream)
          }.not_to change { follower.followed_users.count }
        end
      end
    end
  end

  describe "DELETE /users/:id/unfollow" do
    context "when unauthenticated" do
      it "redirects to login" do
        delete follow_user_path(followed)
        expect(response).to redirect_to(new_user_session_path)
        expect(response).to have_http_status(:found)
      end
    end

    context "when authenticated" do
      before do
        sign_in follower
      end

      context "when currently following the user" do
        before do
          follower.follow(followed)
        end

        it "removes the follow relationship" do
          expect {
            delete follow_user_path(followed, format: :turbo_stream)
          }.to change { follower.followed_users.count }.by(-1)

          expect(follower.followed_users).not_to include(followed)
        end
      end

      context "when not following the user" do
        it "does nothing" do
          expect {
            delete follow_user_path(followed, format: :turbo_stream)
          }.not_to change { follower.followed_users.count }
        end
      end
    end
  end
end
