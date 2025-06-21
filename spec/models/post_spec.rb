require 'rails_helper'

RSpec.describe Post, type: :model do
  subject { create(:post, user:) }
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:post) { create(:post, user: user) }

  it "has a valid factory" do
    expect(subject).to be_valid
  end

  context "validations" do
    it { is_expected.to validate_presence_of(:body) }
  end

  context "associations" do
    it { is_expected.to belong_to(:user).optional(false) }
    it { is_expected.to have_many(:likes).dependent(:destroy) }
    it { is_expected.to have_many(:liked_users).through(:likes).source(:user) }

    it { is_expected.to have_many(:comments).dependent(:destroy) }
  end

  describe "#liked_by?" do
    it "returns true if the post is liked by the given user" do
      subject.mark_as_liked_by(user: other_user)

      expect(subject.liked_by?(other_user)).to be true
    end

    it "returns false if the post is not liked by the given user" do
      expect(subject.liked_by?(other_user)).to be false
    end
  end

  describe "#mark_as_liked_by" do
    it "adds a like for the given user" do
      expect {
        subject.mark_as_liked_by(user: other_user)
      }.to change { subject.reload.liked_users.count }.by(1)
    end

    it "doesn not change the likes count if already liked" do
      subject.mark_as_liked_by(user: other_user)
      expect {
        subject.mark_as_liked_by(user: other_user)
      }.not_to change { subject.reload.liked_users.count }
    end
  end

  describe "#remove_like_from" do
    context "when the user has liked the post" do
      before { subject.mark_as_liked_by(user: other_user) }

      it "removes the like" do
        expect {
          subject.remove_like_from(user: other_user)
        }.to change { subject.reload.liked_users.count }.by(-1)
      end

      it "returns true" do
        expect(subject.remove_like_from(user: other_user)).to be true
      end
    end

    context "when the user has not liked the post" do
      it "returns false" do
        expect(subject.remove_like_from(user: other_user)).to be false
      end
    end
  end

  describe "#sorted_comments_by_date" do
    it "returns comments in reverse chronological order" do
      older = create(:comment, post: subject, created_at: 2.days.ago)
      newer = create(:comment, post: subject, created_at: 1.day.ago)

      sorted = subject.reload.sorted_comments_by_date
      expect(sorted.first).to eq(newer)
      expect(sorted.last).to eq(older)
    end
  end
end
