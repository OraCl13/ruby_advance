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

    it 'should calculate reputation after creating' do
      expect(Reputation).to receive(:calculate).with(subject)
      subject.save!
    end

    it 'should calculate reputation after updating' do
      subject.save!
      expect(Reputation).to_not receive(:calculate)
      subject.update(body: '123')
    end
  end
end
