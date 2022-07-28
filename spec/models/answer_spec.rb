require 'rails_helper'

RSpec.describe Answer, type: :model do
  # Presence
  it { should validate_presence_of :body }

  # Table connections
  it {should belong_to :reply_to}
  it { should have_many(:attachments) }
  it { should accept_nested_attributes_for :attachments }
end
