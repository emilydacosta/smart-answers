# encoding: UTF-8
require_relative '../integration_test_helper'
require_relative 'smart_answer_test_helper'

class HolidayLeaveTest < ActionDispatch::IntegrationTest
  include SmartAnswerTestHelper

  def setup
    visit "/calculate-your-holiday-entitlement"
    click_on "Get started"
  end

  test "Has correct options" do
    assert has_question? "What is your employment status?"
    assert has_content? "Full-time"
    assert has_content? "Part-time"
    assert has_content? "Casual or irregular hours"
    assert has_content? "Annualised hours"
    assert has_content? "Compressed hours"
    assert has_content? "Shift worker"
  end

  test "Full-time" do
    choose "Full-time"
    click_next_step
    assert has_question? "How long will you be employed full-time?"
    assert has_content? "A full year"
    assert has_content? "Part of a year"
  end

  test "Full-time all year flow" do
    choose "Full-time"
    click_next_step
    choose "A full year"
    click_next_step
    choose "5 days per week"
    click_next_step
    assert has_content? "Your paid statutory holiday entitlement is 28 of your working days."
  end

  test "Full-time all year more than 5 days flow" do
    choose "Full-time"
    click_next_step
    choose "A full year"
    click_next_step
    choose "6 or 7 days per week"
    click_next_step
    assert has_content? "get more statutory leave than this even if you work over 5 days a week"
  end

  test "Part-time" do
    choose "Part-time"
    click_next_step
    assert has_question? "How long will you be employed part-time?"
    assert has_content? "A full year"
    assert has_content? "Starting this year"
    assert has_content? "Leaving this year"
  end

  test "Casual or irregular hours" do
    choose "Casual or irregular hours"
    click_next_step
    assert has_question? "Calculate your holiday entitlement based on"
  end

  test "Annualised hours" do
    choose "Annualised hours"
    click_next_step
    assert has_question? "How many hours do you work per year?"
  end

  test "Compressed hours" do
    choose "Compressed hours"
    click_next_step
    assert has_question? "How many hours per week do you work?"
  end

  test "Shift worker" do
    choose "Shift worker"
    click_next_step
    assert has_question? "How long are you working in shifts?"
  end

end
