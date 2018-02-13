require 'rails_helper'

RSpec.describe User, type: :model do

  describe ".nickname" do
    let(:user) { create(:user, firstname: 'Alizé', lastname: "Zuliani") }
    it "returns user's nickname" do
      expect(user.nickname).to eq "Alizé Z"
    end
  end

  describe ".active_for_authentication" do

    context "when registration complete" do
      let!(:user) { create(:registration_complete_user) }

      context "when in valid period" do 
        it "is active for authentication" do
          travel User.allow_unconfirmed_access_for - 1.day
          expect(user.active_for_authentication?).to be true
        end
      end

      context "when in invalid period" do 
        it "is not active for authentication" do
          travel User.allow_unconfirmed_access_for + 1.day
          expect(user.active_for_authentication?).to be false
        end
      end

    end

    context "when identity verified" do
      let!(:user) { create(:identity_verified_user) }

      context "when in valid period" do 
        it "is active for authentication" do
          travel User.allow_unconfirmed_access_for - 1.day
          expect(user.active_for_authentication?).to be true
        end
      end

      context "when in invalid period" do 
        it "is active for authentication" do
          travel User.allow_unconfirmed_access_for + 1.day
          expect(user.active_for_authentication?).to be true
        end
      end
    end

    context "when admin accepted" do
      let!(:user) { create(:admin_accepted_user) }

      context "when in valid period" do 
        it "is active for authentication" do
          travel User.allow_unconfirmed_access_for - 1.day
          expect(user.active_for_authentication?).to be true
        end
      end

      context "when in invalid period" do 
        it "is active for authentication" do
          travel User.allow_unconfirmed_access_for + 1.day
          expect(user.active_for_authentication?).to be true
        end
      end
    end

    context "when admin rejected" do
      let!(:user) { create(:identity_verified_user, verification_state: :admin_rejected) }

      context "when in valid period" do 
        it "is not active for authentication" do
          travel User.allow_unconfirmed_access_for - 1.day
          expect(user.active_for_authentication?).to be false
        end
      end

      context "when in invalid period" do 
        it "is not active for authentication" do
          travel User.allow_unconfirmed_access_for + 1.day
          expect(user.active_for_authentication?).to be false
        end
      end
    end

  end
end
