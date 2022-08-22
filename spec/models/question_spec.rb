require 'rails_helper'

RSpec.describe Question, type: :model do
  it_behaves_like 'Attachments'
  subject { build(:question) }

  # Presence
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  # Table connections
  it { should have_many(:answers) }

  its(:title) { should == 'MyString' }

  describe 'Reputation' do
    let(:user) { create(:user) }
    subject { build(:question, user_id: user.id) }

    it_behaves_like 'Calculates reputation'
  end
end
