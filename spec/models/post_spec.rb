require 'rails_helper'

RSpec.describe Post, type: :model do
  subject { create(:post) }

  it "has a valid factory" do
    expect(subject).to be_valid
  end

  context "validations" do
    it { is_expected.to validate_presence_of(:body) }
  end

  context "associations" do
    it { is_expected.to belong_to(:user).optional(false) }
  end
end
