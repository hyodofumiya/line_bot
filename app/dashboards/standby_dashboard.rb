require "administrate/base_dashboard"

class StandbyDashboard < Administrate::BaseDashboard

  ATTRIBUTE_TYPES = {
    user: Field::BelongsTo.with_options(
      searchable: true,
      searchable_fields: ['employee_number']
    ),
    id: Field::Number,
    date: Field::Date.with_options(searchable: true, format: "%Y-%m-%d"),
    start: Field::DateTime.with_options(format: "%H:%M"),
    break_start: DateTimeField.with_options(format: "%H:%M"),
    break_sum: Field::Number,
    work_status: StatusField,
    all_of_break_sum: Field::Number,
  }.freeze

  COLLECTION_ATTRIBUTES = %i[
  user
  date
  start
  work_status
  all_of_break_sum
  ].freeze

  SHOW_PAGE_ATTRIBUTES = %i[
  user
  date
  start
  work_status
  break_start
  all_of_break_sum
  ].freeze

  FORM_ATTRIBUTES = %i[
  user
  date
  start
  work_status
  break_start
  break_sum
  ].freeze


  def display_resource(standby)
    "勤務状況( #{standby.user.employee_number})"
  end
end
