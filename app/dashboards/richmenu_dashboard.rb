require "administrate/base_dashboard"

class RichmenuDashboard < Administrate::BaseDashboard

  ATTRIBUTE_TYPES = {
    id: Field::Number,
    name: Field::String,
    richmenu_id: Field::Text,
    explanation: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  COLLECTION_ATTRIBUTES = %i[
  id
  name
  richmenu_id
  explanation
  ].freeze

  SHOW_PAGE_ATTRIBUTES = %i[
  id
  name
  richmenu_id
  explanation
  created_at
  updated_at
  ].freeze

  FORM_ATTRIBUTES = %i[
  name
  richmenu_id
  explanation
  ].freeze

end
