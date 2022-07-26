# frozen_string_literal: true

shared_examples_for 'Attachments' do
  it { should have_many(:attachments) }
  it { should accept_nested_attributes_for :attachments }
end
