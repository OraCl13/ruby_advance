require 'rails_helper'

RSpec.describe Question, type: :model do
  # Presence
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  # Table connections
  it { should have_many(:answers) }
  it { should have_many(:attachments) }
end
