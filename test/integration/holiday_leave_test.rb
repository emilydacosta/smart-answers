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
    respond_with "Full-time"
    assert has_question? "How long will you be employed full-time?"
    assert has_content? "A full year"
    assert has_content? "Part of a year"
  end

  test "Full-time all year flow" do
    respond_with "Full-time"
    respond_with "A full year"
    respond_with "5 days per week"
    assert_results_contain "Your paid statutory holiday entitlement is 28 of your working days."
  end

  test "Full-time all year more than 5 days flow" do
    respond_with "Full-time"
    respond_with "A full year"
    respond_with "6 or 7 days per week"
    assert_results_contain "get more statutory leave than this even if you work over 5 days a week"
  end

  test "Part-time" do
    respond_with "Part-time"
    assert has_question? "How long will you be employed part-time?"
    assert has_content? "A full year"
    assert has_content? "Part of a year - I am starting this year"
    assert has_content? "Part of a year - I am leaving this year"
  end

  test "Part-time all year flow" do
    respond_with "Part-time"
    respond_with "A full year"
    respond_with 3
    assert_results_contain "16.8 of your working days"
  end

  test "Part-time part of the year flow" do
    respond_with "Part-time"
    respond_with "Part of a year - I am leaving this year"
    respond_with '2012-05-01'
    respond_with 3
    assert_results_contain "5.5"
  end

  test "Casual or irregular hours" do
    respond_with "Casual or irregular hours"
    assert has_question? "How many hours have you worked?"
  end

  test "Annualised hours" do
    respond_with "Annualised hours"
    assert has_question? "How many hours do you work a year?"
  end

  test "Compressed hours" do
    respond_with "Compressed hours"
    assert has_question? "How many hours per week do you work?"
  end

  test "Shift worker" do
    respond_with "Shift worker"
    assert has_question? "How long are you working in shifts?"
  end

end
