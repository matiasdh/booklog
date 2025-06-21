require 'rails_helper'

RSpec.describe Like, type: :model do
  let(:user) { create(:user) }
  let(:post) { create(:post, user: user) }
  subject    { create(:like, user:, post:) }

  it "has a valid factory" do
    is_expected.to be_valid
  end

  context "validations" do
    it { is_expected.to validate_uniqueness_of(:user).scoped_to(:post_id) }
  end

  context "associations" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:post).counter_cache(true) }
  end
end
