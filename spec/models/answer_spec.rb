require 'rails_helper'

RSpec.describe Answer, type: :model do
  it_behaves_like 'Attachments'
  # Presence
  it { should validate_presence_of :body }

  # Table connections
  it { should belong_to :reply_to }
end
