require 'rails_helper'

RSpec.describe User, type: :model do

  describe ".nickname" do
    let(:user) { create(:user, firstname: 'Alizé', lastname: "Zuliani") }
    it "returns user's nickname" do
      # user = User.first_or_create(firstname: 'Alizé', lastname: "Zuliani")
      p user
      expect(user.nickname).to eq "Alizé Z"
    end
  end
end
