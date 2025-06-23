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

  describe "scopes" do
    let!(:old_post) { create(:post, user: user, created_at: 2.days.ago) }
    let!(:new_post) { create(:post, user: user, created_at: 1.day.ago) }

    before do
      create(:like,    post: old_post, user: user)
      create(:comment, post: old_post, user: user, created_at: 2.days.ago)
      create(:like,    post: new_post, user: user)
      create(:comment, post: new_post, user: user, created_at: 1.day.ago)
    end

    describe ".recent" do
      subject(:posts) { Post.recent.to_a }

      it "orders posts by created_at DESC" do
        expect(posts.map(&:id)).to eq [ new_post.id, old_post.id ]
      end
    end

    describe ".with_associations" do
      subject(:posts) { Post.with_associations.to_a }

      it "eager loads user, likes and comments (and each comment's user)" do
        # trigger load
        posts

        record = posts.first
        expect(record.association(:user)).to be_loaded
        expect(record.association(:likes)).to be_loaded
        expect(record.association(:comments)).to be_loaded

        first_comment = record.comments.first
        expect(first_comment.association(:user)).to be_loaded
      end
    end

    describe ".with_recent_comments" do
      let!(:post)        { create(:post, user: user) }
      let!(:old_comment) { create(:comment, post: post, created_at: 2.days.ago) }
      let!(:new_comment) { create(:comment, post: post, created_at: 1.day.ago) }

      subject(:posts) { Post.with_associations.with_recent_comments.where(id: post.id).to_a }

      it "orders that post's comments by created_at DESC" do
        loaded_post = posts.first
        expect(loaded_post.comments.map(&:id)).to eq [ new_comment.id, old_comment.id ]
      end
    end

    describe ".with_feed" do
      it "chains through with_associations, recent, and with_recent_comments" do
        # Stub the intermediate scopes to return the class itself
        expect(Post).to receive(:with_associations).ordered.and_return(Post)
        expect(Post).to receive(:recent).ordered.and_return(Post)
        expect(Post).to receive(:with_recent_comments).ordered.and_return(Post)

        # Trigger the scope
        Post.with_feed
      end
    end

    describe ".for_user" do
      let(:follower) { create(:user) }
      let(:followed1) { create(:user) }
      let(:followed2) { create(:user) }
      let(:unrelated) { create(:user) }

      let!(:follow1) { create(:user_follow, user: follower, follow: followed1) }
      let!(:follow2) { create(:user_follow, user: follower, follow: followed2) }

      let!(:post1) { create(:post, user: followed1, created_at: 2.days.ago) }
      let!(:post2) { create(:post, user: followed2, created_at: 1.day.ago) }
      let!(:post_unrelated) { create(:post, user: unrelated) }

      subject(:feed) { Post.for_user(follower).order(created_at: :asc) }

      it "returns only posts by users that the given user follows" do
        expect(feed).to contain_exactly(post1, post2)
      end

      it "does not include posts by users not followed" do
        expect(feed).not_to include(post_unrelated)
      end

      context "when the user follows no one" do
        let(:user_with_no_posts) { create(:user) }

        it "returns no posts" do
          expect(Post.for_user(user_with_no_posts)).to be_empty
        end
      end
    end
  end
end
