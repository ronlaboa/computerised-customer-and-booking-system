# frozen_string_literal: true

require_relative 'customers'

# Stores and manages customers. Generates unique customer numbers
# validates new customers
# provides lookups by customer number and a list of all customers.

class LoyaltySchemeStore
  def initialize
    @loyalty_scheme_store = {}
  end

  def create_loyalty_scheme(customer_number, loyalty_scheme_member, frqeucny_of_windows_cleaned)
    customer = LoyaltyScheme.new(customer_number, loyalty_scheme_member, windows)
    add_customer(customer)
    @next_number += 1
    customer
  end

  def find_customer(customer_number)
    @customers[customer_number]
  end

  def all_customers
    @customers.values
  end

  private

  VALID_NAME = /\A[A-Za-z][A-Za-z'\- ]*\z/

  def add_customer(customer)
    unless customer.name.to_s.match?(VALID_NAME)
      raise ArgumentError, 'Name must start with a letter and can only contain letters, spaces, hyphens and apostrophes'
    end

    if @customers.key?(customer.customer_number)
      raise ArgumentError, "Customer number #{customer.customer_number} already exists"
    end

    @customers[customer.customer_number] = customer
  end
end
