require 'rails_helper'

RSpec.describe ComputeUserRank, type: :service do

  # ===================================================================
  context "with REGULAR conditions" do
    let!(:user) { create(:identity_verified_user, rank: :beginner) }
    let!(:past_event_1) {create(:event, start_at: Time.zone.now - 5.days)}
    let!(:event_participation_1) {create(:event_participation, user: user, event: past_event_1)}

    describe "call" do

      context "with only 1 past event" do
        let!(:future_event_1) {create(:event, start_at: Time.zone.now + 5.days)}
        let!(:event_participation_2) {create(:event_participation, user: user, event: future_event_1)}

        it "doesnt set rank to regular" do
          expect { ComputeUserRank.call(user) }.not_to change { user.rank }
        end
      end

      context "with 2 past events, 1 canceled" do
        let!(:past_event_2) {create(:event, start_at: Time.zone.now - 1.days, state: 'canceled')}
        let!(:event_participation_2) {create(:event_participation, user: user, event: past_event_2)}

        it "doesnt set rank to regular" do
          expect { ComputeUserRank.call(user) }.not_to change { user.rank }
        end
      end

      context "with 2 past event" do
        let!(:past_event_2) {create(:event, start_at: Time.zone.now - 1.days)}
        let!(:event_participation_2) {create(:event_participation, user: user, event: past_event_2)}

        it "sets rank to regular" do
          expect { ComputeUserRank.call(user) }.to change { user.rank }.from('beginner').to('regular')
        end
      end

    end
  end

  context "with EXPERT conditions" do
    let!(:user) { create(:identity_verified_user, rank: :beginner) }
    let!(:past_event_1) {create(:event, start_at: Time.zone.now - 5.days)}
    let!(:event_participation_1) {create(:event_participation, user: user, event: past_event_1)}
    let!(:past_event_2) {create(:event, start_at: Time.zone.now - 4.days)}
    let!(:event_participation_2) {create(:event_participation, user: user, event: past_event_2)}
    let!(:past_event_3) {create(:event, start_at: Time.zone.now - 1.days)}
    let!(:event_participation_3) {create(:event_participation, user: user, event: past_event_3)}
    before { allow_any_instance_of(ComputeUserRank).to receive(:avatar).and_return(true) }

    describe "call" do

      context "with no organized event" do
        let!(:past_event_4) {create(:event, start_at: Time.zone.now - 1.days)}
        let!(:event_participation_4) {create(:event_participation, user: user, event: past_event_4)}

        it "doesnt set rank to expert" do
          expect { ComputeUserRank.call(user) }.to change { user.rank }.from('beginner').to('regular')
        end
      end

      context "with all conditions" do
        let!(:organized_event_1) {create(:event, user: user, start_at: Time.zone.now - 1.days)}
        let!(:past_event_4) {create(:event, start_at: Time.zone.now - 1.days)}
        let!(:event_participation_4) {create(:event_participation, user: user, event: past_event_4)}

        it "sets rank to regular" do
          expect { ComputeUserRank.call(user) }.to change { user.rank }.from('beginner').to('expert')
        end
      end

    end
  end


end



