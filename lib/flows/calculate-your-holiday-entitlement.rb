status :draft
section_slug "work"

multiple_choice :employment_status? do
  option "full-time" => :full_time_worked?
  option "part-time" => :part_time_worked?
  option "casual-or-irregular-hours" => :casual_or_irregular_hours?
  option "annualised-hours" => :annualised_hours?
  option "compressed-hours" => :compressed_hours?
  option "shift-worker" => :shift_worker_basis?
end

multiple_choice :full_time_worked? do
  option "year" => :full_time_year
  option "part-year" => :full_time_part_leaving
end

multiple_choice :full_time_year do
  option "5-days" => :done_full_time_5_days
  option "more-than-5" => :done_full_time_more_than_5
end

date_question :full_time_part_leaving do
  save_input_as :start_date
  calculate :days_employed do

  end

end

multiple_choice :part_time_worked? do
  option "year" => :part_time_year_days_worked?
  option "part-year" => :part_time_part_year
end

value_question :part_time_year_days_worked? do
  next_node :done_part_time_year
  calculate :part_time_holiday_entitlement do
    # TODO: clarify exact rounding with Simon Kaplan
    responses.last.to_f * 5.6
  end
end

outcome :done_full_time_5_days
outcome :done_full_time_more_than_5
outcome :done_part_time_year
