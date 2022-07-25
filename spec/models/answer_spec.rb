require 'rails_helper'

RSpec.describe Answer, type: :model do
  # Presence
  it { should validate_presence_of :body }

  # Table connections
  it {should belong_to :reply_to}
end
