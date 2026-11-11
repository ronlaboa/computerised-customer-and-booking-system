# frozen_string_literal: true

require 'date'

# A single booking: its unique booking number, the customer it is for and the
# date of the visit. Bookings are created and validated by BookingStore.

class Bookings

  attr_accessor :customer_number, :booking_number, :date

  def initialize(customer_number, booking_number, date)
    @customer_number = customer_number
    @booking_number = booking_number
    @date = date
  end

  # Returns the date as dd-mm-yy, e.g. "11-11-26".
  def formatted_date
    @date.strftime('%d-%m-%y')
  end


  def to_s
    "Booking #{@booking_number}: customer #{@customer_number} on #{formatted_date}"
  end
end
