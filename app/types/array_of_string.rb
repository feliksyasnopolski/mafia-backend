# frozen_string_literal: true

class ArrayOfString < ActiveRecord::Type::Value
  def type
    :array_of_string
  end

  def cast(values)
    return if values.blank?

    values.map(&:to_s)
  end
end
