require "administrate/base_dashboard"

class TimeCardDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    user: Field::BelongsTo.with_options(
      searchable: true,
      searchable_fields: ['employee_number']
    ),
    id: Field::Number,
    date: Field::Date,
    work_time: Field::Number,
    start_time: Field::DateTime.with_options(format: "%H:%M"),
    finish_time: Field::DateTime.with_options(format: "%H:%M"),
    break_time: Field::Number.with_options(suffix: "分"),
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
  user
  id
  date
  work_time
  finish_time
  break_time
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
  id
  user
  date
  work_time
  start_time
  finish_time
  break_time
  created_at
  updated_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
  user
  date
  work_time
  start_time
  finish_time
  break_time
  ].freeze

  # COLLECTION_FILTERS
  # a hash that defines filters that can be used while searching via the search
  # field of the dashboard.
  #
  # For example to add an option to search for open resources by typing "open:"
  # in the search field:
  #
  #   COLLECTION_FILTERS = {
  #     open: ->(resources) { resources.where(open: true) }
  #   }.freeze
  COLLECTION_FILTERS = {
    #user: ->(resources) { resources.where(user: true) }
  }.freeze

  # Overwrite this method to customize how time cards are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(time_card)
  #   "TimeCard ##{time_card.id}"
  # end
end
