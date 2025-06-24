require 'rails_helper'

RSpec.describe UserFollow, type: :model do
  let(:user) { create(:user) }
  let(:follow) { create(:user) }
  subject { build(:user_follow, user:, follow:) }

  it "has a valid factory" do
    expect(subject).to be_valid
  end

  context "validations" do
    it { is_expected.to validate_uniqueness_of(:user).scoped_to(:follow_id) }

    context "when a user tries to follow themselves" do
      subject { build(:user_follow, user: user, follow: user) }

      it "is invalid" do
        expect(subject).to be_invalid
        expect(subject.errors[:user]).to include("cannot follow themselves")
      end
    end
  end

  context "associations" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:follow).class_name("User") }
  end
end
