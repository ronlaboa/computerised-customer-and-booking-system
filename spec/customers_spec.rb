# frozen_string_literal: true

require_relative '../customers'

RSpec.describe Customers do
  subject(:customer) { described_class.new('1', 'Bob', 10) }

  it 'stores the customer number, name and windows' do
    expect(customer.customer_number).to eq('1')
    expect(customer.name).to eq('Bob')
    expect(customer.windows).to eq(10)
  end

  it 'describes itself with to_s' do
    expect(customer.to_s).to eq('Customer 1: Bob (10 windows)')
  end
end
