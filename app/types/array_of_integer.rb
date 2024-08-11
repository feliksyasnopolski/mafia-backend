# frozen_string_literal: true

class ArrayOfInteger < ActiveRecord::Type::Value
  def type
    :array_of_integer
  end

  def cast(values)
    return [] if values.blank?

    values.map(&:to_i)
  end
end
