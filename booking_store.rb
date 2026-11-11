# frozen_string_literal: true

require_relative 'bookings'

# Stores and manages bookings, linking each one to a customer in the
# CustomerStore.

# Generates unique booking numbers, validates new bookings

# calculates the total windows to clean on a date, and the cost of
# a booking at £5 per property + £1 per window.

class BookingStore
  PRICE_PER_PROPERTY = 5
  PRICE_PER_WINDOW = 1

  def initialize(customer_store)
    @bookings = {}
    @customer_store = customer_store
    @next_number = 1
  end

  def create_booking(customer_number, date)
    booking = Bookings.new(customer_number, @next_number.to_s, date)
    add_booking(booking)
    @next_number += 1
    booking
  end

  def find_booking(booking_number)
    @bookings[booking_number]
  end

  def all_bookings
    @bookings.values
  end

  def bookings_for_customer(customer_number)
    @bookings.values.select { |b| b.customer_number == customer_number }
  end

  # Total windows to be cleaned across all bookings on the given date
  def total_windows_on(date)
    @bookings.values
             .select { |b| b.date == date }
             .sum { |b| @customer_store.find_customer(b.customer_number).windows }
  end

  # £5 per property + £1 per window
  def booking_cost(booking_number)
    booking = find_booking(booking_number)
    raise ArgumentError, "No booking with number #{booking_number}" unless booking

    windows = @customer_store.find_customer(booking.customer_number).windows
    PRICE_PER_PROPERTY + (PRICE_PER_WINDOW * windows)
  end

  private

  def add_booking(booking)
    unless @customer_store.find_customer(booking.customer_number)
      raise ArgumentError, "No customer with number #{booking.customer_number}"
    end

    if booking.date < Date.today
      raise ArgumentError, "Booking date #{booking.formatted_date} is in the past"
    end

    if customer_booked_on?(booking.customer_number, booking.date)
      raise ArgumentError,
            "Customer #{booking.customer_number} already has a booking on #{booking.formatted_date}"
    end

    @bookings[booking.booking_number] = booking
  end

  def customer_booked_on?(customer_number, date)
    @bookings.values.any? { |b| b.customer_number == customer_number && b.date == date }
  end
end
