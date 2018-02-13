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
      context "when in valid period" do 
        let!(:user) { create(:registration_complete_user) }
        
        it "is active for authentication" do
          p "is active for authentication"
          p "begin-------#{Time.now}"
          # user.valid?
          # p user.errors
          p "sms_confirmation_required #{user.sms_confirmation_required?}"
          p "sms_confirmed #{user.sms_confirmed?}"
          p "sms_confirmation_period_valid #{user.sms_confirmation_period_valid?}"
          p "-----------------------"
          p (User.allow_unconfirmed_access_for.nil? || !user.registration_complete? || (user.sms_confirmation_sent_at.present? && user.sms_confirmation_sent_at.utc >= User.allow_unconfirmed_access_for.ago))

          p "User.allow_unconfirmed_access_for.nil? #{User.allow_unconfirmed_access_for.nil?}"
          p "!registration_complete? #{!user.registration_complete?}"
          p "sms_confirmation_sent_at : #{(user.sms_confirmation_sent_at.present? && user.sms_confirmation_sent_at.utc >= User.allow_unconfirmed_access_for.ago)}"

          travel User.allow_unconfirmed_access_for - 1.day do
            p "middle-------#{Time.now}"
            expect(user.active_for_authentication?).to be true
          end
          p "end-------#{Time.now}"
        end
      end

      context "when in invalid period" do 
        let!(:user) { create(:registration_complete_user) }

        it "is not active for authentication" do
          p "is not active for authentication"
          p "begin-------#{Time.now}"
          travel User.allow_unconfirmed_access_for + 1.day do
          p "middle-------#{Time.now}"
            expect(user.active_for_authentication?).to be false
          end
          p "end-------#{Time.now}"
        end
      end

    end

    context "when identity verified" do
      let!(:user) { create(:identity_verified_user) }

      context "when in valid period" do 
        it "is active for authentication" do
          travel User.allow_unconfirmed_access_for - 1.day do
            expect(user.active_for_authentication?).to be true
          end
        end
      end

      context "when in invalid period" do 
        it "is active for authentication" do
          travel User.allow_unconfirmed_access_for + 1.day do
            expect(user.active_for_authentication?).to be true
          end
        end
      end
    end

    context "when admin accepted" do
      let!(:user) { create(:admin_accepted_user) }

      context "when in valid period" do 
        it "is active for authentication" do
          travel User.allow_unconfirmed_access_for - 1.day do
            expect(user.active_for_authentication?).to be true
          end
        end
      end

      context "when in invalid period" do 
        it "is active for authentication" do
          travel User.allow_unconfirmed_access_for + 1.day do
            expect(user.active_for_authentication?).to be true
          end
        end
      end
    end

    context "when admin rejected" do
      let!(:user) { create(:identity_verified_user, verification_state: :admin_rejected) }

      context "when in valid period" do 
        it "is not active for authentication" do
          travel User.allow_unconfirmed_access_for - 1.day do
            expect(user.active_for_authentication?).to be false
          end
        end
      end

      context "when in invalid period" do 
        it "is not active for authentication" do
          travel User.allow_unconfirmed_access_for + 1.day do
            expect(user.active_for_authentication?).to be false
          end
        end
      end
    end

  end
end
