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
end
