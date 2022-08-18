shared_examples_for 'Calculates reputation' do
  it 'should calculate reputation after creating' do
    expect(CalculateReputationJob).to receive(:perform_later).with(subject)
    subject.save!
  end

  it 'should calculate reputation after updating' do
    subject.save!
    expect(CalculateReputationJob).to_not receive(:perform_later)
    subject.update(body: '123')
  end
end
