require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { ability.can :read, Question }
    it { ability.can :read, Answer }
    it { ability.can :read, Comment }

    it { ability.cannot :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { ability.can :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:other) { create :user }


    it { ability.cannot :manage, :all }
    it { ability.can :read, :all }

    it { ability.can :create, Question }
    it { ability.can :create, Answer }
    it { ability.can :create, Comment }

    it { ability.can :update, create(:question, user_id: user), user: user }
    it { ability.cannot :update, create(:question, user_id: other), user: user }

    it { ability.can :update, create(:answer, user_id: user), user: user }
    it { ability.can :update, create(:answer, user_id: other), user: user }
  end
end