require 'rails_helper'

RSpec.describe Answer, type: :model do
  it_behaves_like 'Attachments'
  # Presence
  it { should validate_presence_of :body }

  # Table connections
  it { should belong_to :reply_to }

  describe 'Reputation' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    subject { build(:answer, user_id: user.id, reply_to: question) }

    it_behaves_like 'Calculates reputation'
  end
end
