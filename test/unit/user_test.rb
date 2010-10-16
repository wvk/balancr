require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test 'should fund or create user by nickname using brackets method' do
    assert_nil User.find_by_login('foo')
    user = User['foo']
    assert_not_nil user
    assert_equal User, user.class
    foo = User['foo']
    assert_equal user.id, foo.id
  end

  test 'should be able to join project using joins' do
    project = Project['test project']
    user    = User['test user']
    assert_equal [], project.users
    assert user.joins(project)
    assert_equal [user], project.reload.users
  end

  test 'joins should return a Membership object' do
    project = Project['test project']
    user    = User['test user']
    assert_equal Membership, user.joins(project).class
  end

  test 'should be able to spend money on project using spends' do
    project = Project['test project']
    user    = User['test user']
    user.joins(project)
    user.spends(42).on(project)
    assert_equal 42, user.expenses.sum(:amount)
  end

  test 'spends should return Expense object' do
    user = User['test user']
    assert_equal Expense, user.spends(42).class
  end

  test 'amount_spent_on should return sum of spent amounts on project' do
    project = Project['test project']
    user    = User['test user']
    user.joins(project)
    user.spends(42).on(project)
    user.spends(23).on(project)
    assert_equal 65, user.amount_spent_on(project)
  end

  test 'spendings on different projects should not influence each other' do
    project_a = Project['test project A']
    project_b = Project['test project B']
    user    = User['test user']
    user.joins(project_a)
    user.joins(project_b)
    user.spends(42).on(project_a)
    user.spends(23).on(project_a)
    user.spends(23).on(project_b)
    assert_equal 65, user.amount_spent_on(project_a)
    assert_equal 23, user.amount_spent_on(project_b)
  end

  test 'should be able to pay amounts to other users using pays' do
    user1 = User['user 1']
    user2 = User['user 2']
    assert_difference('Payment.count') do
      user1.pays(42).to(user2)
    end
    assert_equal 42, user1.issued_payments.sum(:amount)
    assert_equal 42, user2.received_payments.sum(:amount)
  end

  test 'amount_payed_to should return sum of payed amounts to specified user' do
    user1 = User['user 1']
    user2 = User['user 2']
    user1.pays(42).to user2
    user1.pays(23).to user2
    assert_equal 65, user1.amount_payed_to(user2)
    assert_equal 0, user2.amount_payed_to(user1)
  end

  test 'amount_received_from should return sum of received amounts from specified user' do
    user1 = User['user 1']
    user2 = User['user 2']
    user1.pays(42).to user2
    user1.pays(23).to user2
    assert_equal 0,  user1.amount_received_from(user2)
    assert_equal 65, user2.amount_received_from(user1)
  end

end
