json.array! @users do |user|
  json.id user.id
  json.employee_number user.employee_number
  json.line_id user.line_id
end
