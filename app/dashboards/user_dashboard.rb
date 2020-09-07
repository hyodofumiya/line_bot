require "administrate/base_dashboard"

class UserDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    standby: Field::HasOne,
    time_cards: Field::HasMany,
    user_groups: Field::HasMany,
    groups: Field::HasMany,
    id: Field::Number,
    family_name: Field::String,
    first_name: Field::String,
    employee_number: Field::Number.with_options(searchable: true),
    line_id: Field::Text,
    admin_user: Field::Boolean,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    email: Field::String,
    encrypted_password: Field::String,
    reset_password_token: Field::String,
    reset_password_sent_at: Field::DateTime,
    remember_created_at: Field::DateTime,
    on_work: StatusField,
  }.freeze

  COLLECTION_ATTRIBUTES = %i[
  employee_number
  family_name
  first_name
  admin_user
  on_work
  ].freeze

  SHOW_PAGE_ATTRIBUTES = %i[
  employee_number
  family_name
  first_name
  admin_user
  created_at
  updated_at
  ].freeze

  FORM_ATTRIBUTES = %i[
  employee_number
  family_name
  first_name
  line_id
  admin_user
  ].freeze

  COLLECTION_FILTERS = {}.freeze

  def display_resource(user)
     "#{user.employee_number}"
  end
end
