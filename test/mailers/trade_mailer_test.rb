require 'test_helper'

class TradeMailerTest < ActionMailer::TestCase
  test "newtrade" do
    mail = TradeMailer.newtrade
    assert_equal "Newtrade", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "proposal" do
    mail = TradeMailer.proposal
    assert_equal "Proposal", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "aprove" do
    mail = TradeMailer.aprove
    assert_equal "Aprove", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "refuse" do
    mail = TradeMailer.refuse
    assert_equal "Refuse", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
