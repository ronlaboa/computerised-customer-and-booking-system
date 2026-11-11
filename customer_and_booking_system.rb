# frozen_string_literal: true
require 'date'
require_relative 'customer_store'
require_relative 'booking_store'
customers = CustomerStore.new
bookings  = BookingStore.new(customers)
def show_menu
  puts '1. Add customer'
  puts '2. List customers'
  puts '3. Add booking'
  puts '4. List all bookings'
  puts '5. List bookings for a customer'
  puts '6. Find booking by number'
  puts '7. Total windows on a date'
  puts '8. Cost of a booking'
  puts '0. Exit'
end

def ask(prompt)
  print "#{prompt}: "
  gets.chomp
end

def clear_screen
  print "\e[2J\e[H"
end

def pause
  print "\nPress Enter to continue..."
  gets
end

def print_bookings(list)
  puts format('%-40s %-30s %s', 'Booking number', 'Customer number', 'Date')
  list.each do |b|
    puts format('%-40s %-30s %s', b.booking_number, b.customer_number, b.formatted_date)
  end
end

loop do
  clear_screen
  show_menu
  choice = ask('Choose an option')
  break if choice == '0'

  clear_screen
  begin
    case choice
    when '1'
      name = ask('Name')
      windows = Integer(ask('Number of windows'))
      puts "Created: #{customers.create_customer(name, windows)}"
    when '2'
      list = customers.all_customers
      if list.empty?
        puts 'No customers yet'
      else
        puts format('%-40s %-30s %4s', 'Customer number', 'Customer name', 'Number of windows')
        list.each do |c|
          puts format('%-40s %-30s %d', c.customer_number, c.name, c.windows)
        end
      end
    when '3'
      number = ask('Customer number')
      date   = Date.strptime(ask('Date (dd-mm-yy)'), '%d-%m-%y')
      puts "Created: #{bookings.create_booking(number, date)}"
    when '4'
      list = bookings.all_bookings
      if list.empty?
        puts 'No bookings yet'
      else
        print_bookings(list)
      end
    when '5'
      list = bookings.bookings_for_customer(ask('Customer number'))
      if list.empty?
        puts 'No bookings for this customer'
      else
        print_bookings(list)
      end
    when '6'
      booking = bookings.find_booking(ask('Booking number'))
      if booking
        print_bookings([booking])
      else
        puts 'Not found'
      end
    when '7'
      date = Date.strptime(ask('Date (dd-mm-yy)'), '%d-%m-%y')
      puts "Total windows on #{date.strftime('%d-%m-%y')}: #{bookings.total_windows_on(date)}"
    when '8'
      number = ask('Booking number')
      puts "Cost of booking #{number}: £#{bookings.booking_cost(number)}"
    else
      puts 'Invalid option'
    end
  rescue ArgumentError => e
    puts "Error: #{e.message}"
  end
  pause
end
