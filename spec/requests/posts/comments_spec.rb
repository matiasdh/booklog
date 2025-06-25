require 'rails_helper'

RSpec.describe "Posts::Comments", type: :request do
  let!(:user) { create(:user) }
  let(:post_record) { create(:post) }
  let(:comment_params) { { comment: attributes_for(:comment) } }

  describe "POST /posts/:id/comments" do
    context "when unauthenticated" do
      it "redirects to login" do
        post post_comments_path(post_record, format: :turbo_stream), params: comment_params
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "with valid params" do
      before do
        get "/"
        sign_in user
        post post_comments_path(post_record, format: :turbo_stream), params: comment_params
      end

      let(:comment) { Comment.last }

      it "creates a comment" do
        expect(Comment.count).to eq(1)
      end

      it "associates the comment to the correct post" do
        expect(comment.post).to eq(post_record)
      end

      it "associates the comment to the current user" do
        expect(comment.user).to eq(user)
      end

      it "sets the correct comment body" do
        expect(comment.body).to eq(comment_params[:comment][:body])
      end

      it "renders the comment content in the response" do
        expect(response.body).to include(comment.body)
      end
    end

    it "returns unprocessable entity if comment is invalid" do
      expect {
        post post_comments_path(post_record, format: :turbo_stream), params: { comment: { body: "" } }
      }.not_to change(Comment, :count)

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
