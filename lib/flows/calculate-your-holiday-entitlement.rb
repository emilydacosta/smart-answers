status :draft

multiple_choice :employment_status? do
  option :full_time => :full_time_worked?
  option :part_time => :part_time_worked?
  option :casual_or_irregular => :casual_or_irregular_hours?
  option :annualised_hours => :annualised_hours?
  option :compressed_hours => :compressed_hours?
  option :shift_worker => :shift_worker_basis?
end
