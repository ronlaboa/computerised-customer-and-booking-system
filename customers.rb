# frozen_string_literal: true

# A single customer: their unique customer number, name and the number of
# windows at their property. Customers are created and validated by
# CustomerStore.

class Customers
  attr_accessor :customer_number, :name, :windows

  def initialize(customer_number, name, windows)
    @customer_number = customer_number
    @name = name
    @windows = windows
  end

  def to_s
    "Customer #{@customer_number}: #{@name} (#{@windows} windows)"
  end
end


