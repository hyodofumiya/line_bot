require "administrate/base_dashboard"

class TimeCardDashboard < Administrate::BaseDashboard

  ATTRIBUTE_TYPES = {
    user: Field::BelongsTo.with_options(
      searchable: true,
      searchable_fields: ['employee_number']
    ),
    id: Field::Number,
    date: Field::Date.with_options(searchable: true, format: "%Y-%m-%d"),
    start_time: Field::DateTime.with_options(format: "%H:%M"),
    finish_time: Field::DateTime.with_options(format: "%H:%M"),
    work_time: Field::Number,
    break_time: Field::Number.with_options(suffix: "分"),
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  COLLECTION_ATTRIBUTES = %i[
  user
  date
  start_time
  finish_time
  work_time
  break_time
  ].freeze

  SHOW_PAGE_ATTRIBUTES = %i[
  user
  date
  start_time
  finish_time
  work_time
  break_time
  created_at
  updated_at
  ].freeze

  FORM_ATTRIBUTES = %i[
  user
  date
  start_time
  finish_time
  break_time
  ].freeze

  def display_resource(time_card)
    "(#{time_card.date})"
  end
end
