require File.dirname(__FILE__) + '/../test_helper'

class BrainTreeGatewayTest < Test::Unit::TestCase
  def setup
    @card = Freemium::CreditCard.new(
      :number => '4111111111111111',
      :type => 'visa',
      :month => 10,
      :year => 2010,
      :first_name => "Montgomery",
      :last_name => "Burns"
    )
    @address = Freemium::Address.new(
      :street => "1000 Mammon Lane",
      :city => "Springfield",
      :state => "Illinois",
      :zip => 62701,
      :email => "montgomery@snpp.com"
    )

    @gateway = Freemium::Gateways::BrainTree.new
    @gateway.username = 'demo'
    @gateway.password = 'password'
  end

  def test_lifecycle
    # store
    post = @gateway.store(@card, @address)
    vault_id = post.response['customer_vault_id']
    assert post.success?, "transaction was accepted"
    assert_not_nil vault_id, "customer was assigned a vault_id"
    assert_equal "Customer Added", post.response['responsetext']

    # charge
    transaction = @gateway.charge(vault_id, Money.new(1295))
    assert transaction.is_a?(Freemium::Transaction)
    assert transaction.success?
    assert_equal vault_id, transaction.billing_key

    # update
    @card.last_name = "Burninator"
    post = @gateway.update(vault_id, @card)
    assert post.success?
    assert_equal "Customer Update Successful", post.response['responsetext']

    # delete (cancel)
    assert @gateway.cancel(vault_id)
  end

  def test_failed_storage
    @card.number = ''
    post = @gateway.store(@card, @address)
    assert !post.success?
    assert post.response['response']
  end

  def test_failed_charge
    post = @gateway.store(@card, @address)
    vault_id = post.response['customer_vault_id']

    # any amount under one dollar should fail in the BrainTree test environment
    transaction = @gateway.charge(vault_id, Money.new(54))
    assert !transaction.success?
  end
end