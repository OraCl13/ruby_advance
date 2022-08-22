class CalculateReputationJob < ApplicationJob
  queue_as :default

  def perform(object)
    reputation = Reputation.calculate(object)
    User.find(object.user_id).update(reputation: reputation)
  end
end
