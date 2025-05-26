require 'rails_helper'

RSpec.describe User, type: :model do
  context "validations" do
    it { validates_presence_of(:email).uniqueness(true) }
    it { validates_presence_of(:username).uniqueness(true) }
  end
end
