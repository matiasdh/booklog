require 'rails_helper'

RSpec.describe User, type: :model do
  subject { create :user }
  let(:user_1) { create :user }
  it "has a valid factory" do
    expect(subject).to be_valid
  end

  context "validations" do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:username) }
  end

  context "associations" do
    it { is_expected.to have_many(:posts).dependent(:destroy) }
    it { is_expected.to have_many(:likes).dependent(:destroy) }
    it { is_expected.to have_many(:liked_posts).through(:likes).source(:post) }
    it { is_expected.to have_many(:comments).dependent(:destroy) }
    it { is_expected.to have_many(:user_follows).dependent(:destroy) }
    it { is_expected.to have_many(:followed_users).through(:user_follows).source(:follow) }
  end

  describe "#follows?" do
    it "when a user follows a user returns true" do
      subject.follow user_1
      expect(subject.follows?(user_1)).to be_truthy
    end

    it "when a user does not follows a user returns false" do
      subject.unfollow user_1
      expect(subject.follows?(user_1)).to be_falsey
    end
  end

  describe "#follow" do
    context "when a user follows a non followed user" do
      it "returns true" do
        expect(subject.follow(user_1)).to be true
      end

      it "updates the subject followed_users collection" do
        expect { subject.follow(user_1) }.to change {
          subject.reload.followed_users
        }.from([])
        .to([ user_1 ])
      end

      it "does not change the user_1 followed_users collection" do
        expect { subject.follow(user_1) }.not_to change {
          user_1.reload.followed_users.to_a
        }
      end
    end

    context "when a user follows a followed user" do
      before do
        subject.follow(user_1)
      end
      it "returns true" do
        expect(subject.follow(user_1)).to be true
      end

      it "does not change the subject followed_users collection" do
        expect { subject.follow(user_1) }.not_to change {
          subject.reload.followed_users.to_a
        }
      end

      it "does not change the user_1 followed_users collection" do
        expect { subject.follow(user_1) }.not_to change {
          user_1.reload.followed_users.to_a
        }
      end
    end

    it "when a user follows the subject, does not change its followed_users collection " do
      expect { user_1.follow(subject) }.not_to change {
        subject.reload.followed_users.to_a
      }
    end

    context "when a user tries to follow itself" do
      it "returns false" do
        expect(subject.follow(subject)).to be false
      end

      it "does not change the followed_users collection" do
        expect { user_1.follow(subject) }.not_to change {
          subject.reload.followed_users.to_a
        }
      end
    end
  end

  describe "#unfollow" do
    context "a followed user" do
      before do
        subject.follow user_1
      end
      it "returns true" do
        expect(subject.unfollow(user_1)).to be true
      end

      it "updates the subject followed_users collection" do
        expect { subject.unfollow(user_1) }.to change {
          subject.reload.followed_users
        }.from([ user_1 ])
        .to([])
      end
    end
  end
end
