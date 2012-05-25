status :draft

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
  option "part-year" => :full_time_part
end

multiple_choice :full_time_year do
  option "5-days" => :done_full_time_5_days
  option "more-than-5" => :done_full_time_more_than_5
end

outcome :done_full_time_5_days
outcome :done_full_time_more_than_5
