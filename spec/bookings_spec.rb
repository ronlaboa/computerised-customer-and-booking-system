# frozen_string_literal: true

require_relative '../bookings'

RSpec.describe Bookings do
  subject(:booking) { described_class.new('1', '7', Date.new(2030, 11, 5)) }

  it 'stores the customer number, booking number and date' do
    expect(booking.customer_number).to eq('1')
    expect(booking.booking_number).to eq('7')
    expect(booking.date).to eq(Date.new(2030, 11, 5))
  end

  it 'formats the date as dd-mm-yy' do
    expect(booking.formatted_date).to eq('05-11-30')
  end

  it 'describes itself with to_s' do
    expect(booking.to_s).to eq('Booking 7: customer 1 on 05-11-30')
  end
end
