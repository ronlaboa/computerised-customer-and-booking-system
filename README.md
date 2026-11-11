# computerised-customer-and-booking-system
A computerised customer and booking system for a window cleaner

## Running the app

```
ruby customer_and_booking_system.rb
```

Use the menu to add and list customers, add and look up bookings, see the
total windows to be cleaned on a date, and the cost of a booking
(£5 per property + £1 per window). Dates are entered as `dd-mm-yy`.

## Menu overview

| Option | Action | Prompts for |
|--------|--------|-------------|
| 1 | Add customer | Name, number of windows |
| 2 | List customers | – |
| 3 | Add booking | Customer number, date (`dd-mm-yy`) |
| 4 | List all bookings | – |
| 5 | List bookings for a customer | Customer number |
| 6 | Find booking by number | Booking number |
| 7 | Total windows on a date | Date (`dd-mm-yy`) |
| 8 | Cost of a booking | Booking number |
| 0 | Exit | – |

- The screen is cleared before each menu, and after each action you are asked
  to press Enter to continue.
- Invalid menu choices show `Invalid option`; invalid input (e.g. a non-numeric
  window count or a badly formatted date) shows an `Error:` message instead of
  crashing.
- Bookings are listed with their booking number, customer number and date.

## Running the tests

```
bundle install
bundle exec rspec
```
