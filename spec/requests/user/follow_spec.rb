require 'rails_helper'

RSpec.describe "User::Follows", type: :request do
  describe "GET /create" do
    it "returns http success" do
      get "/user/follow/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /destroy" do
    it "returns http success" do
      get "/user/follow/destroy"
      expect(response).to have_http_status(:success)
    end
  end
end
