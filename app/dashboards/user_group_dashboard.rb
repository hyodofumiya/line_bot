require "administrate/base_dashboard"

class UserGroupDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    user: Field::BelongsTo,
    group: Field::BelongsTo,
    id: Field::Number,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  COLLECTION_ATTRIBUTES = %i[
  user
  group
  id
  created_at
  ].freeze

  SHOW_PAGE_ATTRIBUTES = %i[
  user
  group
  id
  created_at
  updated_at
  ].freeze

  FORM_ATTRIBUTES = %i[
  user
  group
  ].freeze

end
