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
    response = @gateway.store(@card, @address)
    vault_id = response.billing_key
    assert response.success?, "transaction was accepted"
    assert_not_nil vault_id, "customer was assigned a vault_id"
    assert_equal "Customer Added", response['responsetext']

    # charge
    transaction = @gateway.charge(vault_id, Money.new(1295))
    assert transaction.is_a?(Freemium::Transaction)
    assert transaction.success?
    assert_equal vault_id, transaction.billing_key

    # update
    @card.last_name = "Burninator"
    response = @gateway.update(vault_id, @card)
    assert response.success?
    assert_equal "Customer Update Successful", response.message

    # delete (cancel)
    response = @gateway.cancel(vault_id)
    assert response.success?
  end

  def test_failed_storage
    @card.number = ''
    response = @gateway.store(@card, @address)
    assert !response.success?
    assert response['response']
  end

  def test_failed_charge
    response = @gateway.store(@card, @address)
    vault_id = response.billing_key

    # any amount under one dollar should fail in the BrainTree test environment
    transaction = @gateway.charge(vault_id, Money.new(54))
    assert !transaction.success?
  end

  def test_storage_without_address
    response = @gateway.store(@card)
    assert response.success?, "transaction was accepted"
    assert_not_nil response.billing_key
    assert_equal "Customer Added", response.message
  end
end