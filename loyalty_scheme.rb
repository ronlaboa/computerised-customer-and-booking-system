# frozen_string_literal: true

# A single customer: their unique customer number, name and the number of
# windows at their property. Customers are created and validated by
# CustomerStore.

class LoyaltyScheme
  attr_accessor :customer_number, :loyalty_scheme_member, :frequency_of_windows_cleaned

  def initialize(customer_number, name, windows)
    @customer_number = customer_number
    @loyalty_scheme_member = loyalty_scheme_member
    @frequency_of_windows_cleaned = frequency_of_windows_cleaned
  end

  def to_s
    "Customer #{@customer_number}: #{@loyalty_scheme_member} (#{@frequency_of_windows_cleaned} windows)"
  end
end


