# frozen_string_literal: true

Rails.application.config.to_prepare do
  ActiveModel::Type.register(:array_of_string, ArrayOfString)
  ActiveModel::Type.register(:array_of_integer, ArrayOfInteger)
end
