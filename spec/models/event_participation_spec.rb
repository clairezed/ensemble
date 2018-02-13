require 'rails_helper'

RSpec.describe EventParticipation, type: :model do

  describe "#create" do 
    let(:participant) { create(:admin_accepted_user) }

    context "when opened && not_full event" do
      let(:event) { create(:event, visibility: :opened, participants_max: 10) }

      it "is possible to participate" do
        expect do 
          event.event_participations.create(user_id: participant.id)
        end.to change{ event.event_participations.count }.by(1)
      end
    end

    context "when opened && full event" do
      let(:event) { create(:event, visibility: :opened, participants_max: 1) }
      let(:other_participant) { create(:admin_accepted_user) }
      let!(:other_participation) { create(:event_participation, event: event, user: other_participant) }

      it "is not possible to participate" do
        expect do 
          event.event_participations.create(user_id: participant.id)
        end.not_to change{ event.event_participations.count }
      end
    end

    context "when closed && full event" do
      let(:event) { create(:event, visibility: :closed, participants_max: 1) }
      let(:other_participant) { create(:admin_accepted_user) }
      let!(:other_participation) { create(:event_participation, event: event, user: other_participant) }

      it "is possible to participate" do
        expect do 
          event.event_participations.create(user_id: participant.id)
        end.to change{ event.event_participations.count }
      end
    end
  end

  # describe ".next_in_time" do
  #   let!(:event1) { create(:event, start_at: Time.current + 3.weeks) }
  #   let!(:event2) { create(:event, start_at: Time.current + 1.week) }
  #   let!(:event3) { create(:event, start_at: Time.current + 2.weeks) }

  #   it "returns event with nearest in time first" do
  #     events = Event.all.next_in_time
  #     expect(events.first).to eq event2
  #     expect(events.last).to eq event1
  #   end
  # end
end