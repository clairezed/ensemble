require 'rails_helper'

RSpec.describe Event, type: :model do

  describe ".next_in_time" do
    let!(:event1) { create(:event, start_at: Time.current + 3.weeks) }
    let!(:event2) { create(:event, start_at: Time.current + 1.week) }
    let!(:event3) { create(:event, start_at: Time.current + 2.weeks) }

    it "returns event with nearest in time first" do
      p event1.errors unless event1.valid?
      p event2.errors unless event2.valid?
      p event3.errors unless event3.valid?
      events = Event.all.next_in_time
      expect(events.first).to eq event2
      expect(events.last).to eq event1
    end
  end
end
