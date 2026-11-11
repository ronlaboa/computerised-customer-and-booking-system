# frozen_string_literal: true

require_relative '../customer_store'
require_relative '../booking_store'

RSpec.describe BookingStore do
  subject(:store) { described_class.new(customers) }

  let(:customers) { CustomerStore.new }
  let(:today) { Date.today }
  let(:tomorrow) { Date.today + 1 }

  before do
    customers.create_customer('Bob', 10) # customer "1"
    customers.create_customer('Ann', 4)  # customer "2"
  end

  describe '#create_booking' do
    it 'creates a booking with a generated number' do
      booking = store.create_booking('1', tomorrow)

      expect(booking).to be_a(Bookings)
      expect(booking.booking_number).to eq('1')
      expect(booking.customer_number).to eq('1')
      expect(booking.date).to eq(tomorrow)
    end

    it 'gives each booking a unique, incrementing number' do
      first = store.create_booking('1', tomorrow)
      second = store.create_booking('2', tomorrow)

      expect(first.booking_number).to eq('1')
      expect(second.booking_number).to eq('2')
    end

    it 'accepts a booking for today' do
      expect { store.create_booking('1', today) }.not_to raise_error
    end

    it 'rejects an unknown customer' do
      expect { store.create_booking('99', tomorrow) }
        .to raise_error(ArgumentError, 'No customer with number 99')
    end

    it 'rejects a date in the past' do
      expect { store.create_booking('1', today - 1) }
        .to raise_error(ArgumentError, /in the past/)
    end

    it 'rejects a second booking for the same customer on the same day' do
      store.create_booking('1', tomorrow)

      expect { store.create_booking('1', tomorrow) }
        .to raise_error(ArgumentError, /already has a booking/)
    end

    it 'allows different customers to book the same day' do
      store.create_booking('1', tomorrow)

      expect { store.create_booking('2', tomorrow) }.not_to raise_error
    end

    it 'allows the same customer to book on different days' do
      store.create_booking('1', tomorrow)

      expect { store.create_booking('1', tomorrow + 1) }.not_to raise_error
    end

    it 'does not use up a booking number when a booking is rejected' do
      expect { store.create_booking('99', tomorrow) }.to raise_error(ArgumentError)

      expect(store.create_booking('1', tomorrow).booking_number).to eq('1')
    end
  end

  describe '#find_booking' do
    it 'returns the booking with the given number' do
      booking = store.create_booking('1', tomorrow)

      expect(store.find_booking('1')).to eq(booking)
    end

    it 'returns nil when there is no such booking' do
      expect(store.find_booking('99')).to be_nil
    end
  end

  describe '#all_bookings' do
    it 'returns an empty array when there are no bookings' do
      expect(store.all_bookings).to eq([])
    end

    it 'returns every booking' do
      first = store.create_booking('1', tomorrow)
      second = store.create_booking('2', tomorrow)

      expect(store.all_bookings).to eq([first, second])
    end
  end

  describe '#bookings_for_customer' do
    it 'returns only that customer\'s bookings' do
      mine = store.create_booking('1', tomorrow)
      store.create_booking('2', tomorrow)

      expect(store.bookings_for_customer('1')).to eq([mine])
    end

    it 'returns an empty array when the customer has no bookings' do
      expect(store.bookings_for_customer('1')).to eq([])
    end
  end

  describe '#total_windows_on' do
    it 'adds up the windows of every customer booked on the date' do
      store.create_booking('1', tomorrow)
      store.create_booking('2', tomorrow)
      store.create_booking('1', tomorrow + 1)

      expect(store.total_windows_on(tomorrow)).to eq(14)
    end

    it 'returns 0 when nothing is booked on the date' do
      expect(store.total_windows_on(tomorrow)).to eq(0)
    end
  end

  describe '#booking_cost' do
    it 'charges 5 per property plus 1 per window' do
      store.create_booking('1', tomorrow) # 10 windows
      store.create_booking('2', tomorrow) # 4 windows

      expect(store.booking_cost('1')).to eq(15)
      expect(store.booking_cost('2')).to eq(9)
    end

    it 'raises an error for an unknown booking number' do
      expect { store.booking_cost('99') }
        .to raise_error(ArgumentError, 'No booking with number 99')
    end
  end

  describe '#add_booking' do
    it 'is private' do
      booking = Bookings.new('1', '1', tomorrow)

      expect { store.add_booking(booking) }.to raise_error(NoMethodError)
    end
  end
end
