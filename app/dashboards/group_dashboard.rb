require "administrate/base_dashboard"

class GroupDashboard < Administrate::BaseDashboard

  ATTRIBUTE_TYPES = {
    user_groups: Field::HasMany,
    users: Field::HasMany,
    id: Field::Number,
    line_id: Field::Text,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  COLLECTION_ATTRIBUTES = %i[
  user_groups
  users
  id
  line_id
  ].freeze

  SHOW_PAGE_ATTRIBUTES = %i[
  user_groups
  users
  id
  line_id
  created_at
  updated_at
  ].freeze

  FORM_ATTRIBUTES = %i[
  user_groups
  users
  line_id
  ].freeze


end
