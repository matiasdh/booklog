require 'rails_helper'

RSpec.describe "Posts::Comments", type: :request do
  describe "GET /create" do
    it "returns http success" do
      get "/posts/comments/create"
      expect(response).to have_http_status(:success)
    end
  end
end
