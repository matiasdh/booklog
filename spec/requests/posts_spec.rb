# spec/requests/posts_spec.rb
require 'rails_helper'

RSpec.describe "Posts", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:post_record) { create(:post, user: user) }

  describe "GET / (discovery feed)" do
    context "when unauthenticated" do
      it "redirects to login" do
        get "/"
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

   context "when authenticated" do
    before do
      sign_in user
      post_record
    end
    it "renders index for authenticated users" do
      get "/"
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("What&#39;s on your mind?")
      expect(response.body).to include(post_record.body)
    end
   end
  end

  describe "POST /posts" do
    let(:params) { { post: attributes_for(:post) } }

    context "when unauthenticated" do
      it "redirects to login" do
        post posts_path, params: params
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when authenticated" do
      before { sign_in user }

      it "creates a new post" do
        expect {
          post posts_path(format: :turbo_stream), params: params
        }.to change(Post, :count).by(1)
      end

      it "does not raise an error with invalid params" do
        expect {
          post posts_path(format: :turbo_stream), params: { post: { body: "" } }
        }.not_to raise_error
      end

      it "does not create a post with invalid params" do
        expect {
          post posts_path(format: :turbo_stream), params: { post: { body: "" } }
        }.not_to change(Post, :count)
      end

      it "responds with success" do
        post posts_path(format: :turbo_stream), params: params
        expect(response).to have_http_status(:success)
      end
    end
  end
end
