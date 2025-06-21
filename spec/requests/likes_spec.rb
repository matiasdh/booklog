require 'rails_helper'

RSpec.describe "Posts::Likes", type: :request do
  let!(:post_record) { create(:post) }
  let!(:user) { create(:user) }

  describe "POST /posts/:id/like" do
    context "when unauthenticated" do
      it "redirects to the login page" do
        post like_post_path(post_record)
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when authenticated" do
      before do
        sign_in user
      end

      context "when the post is not yet liked by the user" do
        it "creates a like" do
          expect {
            post like_post_path(post_record, format: :json)
          }.to change(Like, :count).by(1)
        end

        it "liked by the user returns true" do
          expect {
            post like_post_path(post_record, format: :json)
          }.to change { post_record.liked_by?(user) }.from(false).to true
        end

        it "increments the post's likes count by 1" do
          expect {
            post like_post_path(post_record, format: :json)
          }.to change { post_record.reload.likes_count }.by(1)
        end
      end

      context "when the post is already liked by the user" do
        before do
          post_record.mark_as_liked_by(user: user)
        end

        it "does not create a duplicate like" do
          expect {
            post like_post_path(post_record, format: :json)
          }.not_to change { post_record.likes.count }
        end

        it "returns unprocessable entity" do
          post like_post_path(post_record, format: :json)
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end
  describe "DELETE /posts/:id/like" do
    context "when unauthenticated" do
      it "redirects to the login page" do
        delete like_post_path(post_record)
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when authenticated" do
      before do
        sign_in user
      end

      context "when the post is liked by the user" do
        before do
          post_record.mark_as_liked_by(user: user)
        end

        it "removes the like" do
          expect {
            delete like_post_path(post_record, format: :json)
          }.to change { post_record.likes.count }.by(-1)
        end
        it "liked by the user returns false" do
          expect {
            delete like_post_path(post_record, format: :json)
          }.to change { post_record.reload.liked_by?(user) }.from(true).to false
        end
      end

      context "when the post is not liked by the user" do
        it "does not remove any like" do
          expect {
            delete like_post_path(post_record, format: :json)
          }.not_to change { post_record.likes.count }
        end

        it "returns unprocessable entity" do
          delete like_post_path(post_record, format: :json)
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end
end
