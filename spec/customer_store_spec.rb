# frozen_string_literal: true

require_relative '../customer_store'

RSpec.describe CustomerStore do
  subject(:store) { described_class.new }

  describe '#create_customer' do
    it 'creates a customer with a generated number' do
      customer = store.create_customer('Bob', 10)

      expect(customer).to be_a(Customers)
      expect(customer.customer_number).to eq('1')
      expect(customer.name).to eq('Bob')
      expect(customer.windows).to eq(10)
    end

    it 'gives each customer a unique, incrementing number' do
      numbers = %w[Bob Ann Cy].map { |n| store.create_customer(n, 5).customer_number }

      expect(numbers).to eq(%w[1 2 3])
    end

    it 'strips leading and trailing spaces from the name' do
      expect(store.create_customer('  Bob  ', 5).name).to eq('Bob')
    end

    it 'accepts spaces, hyphens and apostrophes inside a name' do
      ["Mary Jane", "O'Neil", 'Anne-Marie'].each do |name|
        expect { store.create_customer(name, 5) }.not_to raise_error
      end
    end

    ['', '   ', '1Bob', 'Bob1', '-Bob', "'Bob", 'B@d'].each do |name|
      it "rejects the invalid name #{name.inspect}" do
        expect { store.create_customer(name, 5) }
          .to raise_error(ArgumentError, /Name must start with a letter/)
      end
    end

    it 'does not use up a customer number when a name is rejected' do
      expect { store.create_customer('B@d', 5) }.to raise_error(ArgumentError)

      expect(store.create_customer('Bob', 5).customer_number).to eq('1')
    end
  end

  describe '#find_customer' do
    it 'returns the customer with the given number' do
      customer = store.create_customer('Bob', 10)

      expect(store.find_customer('1')).to eq(customer)
    end

    it 'returns nil when there is no such customer' do
      expect(store.find_customer('99')).to be_nil
    end
  end

  describe '#all_customers' do
    it 'returns an empty array when there are no customers' do
      expect(store.all_customers).to eq([])
    end

    it 'returns every customer' do
      bob = store.create_customer('Bob', 10)
      ann = store.create_customer('Ann', 4)

      expect(store.all_customers).to eq([bob, ann])
    end
  end

  describe '#add_customer' do
    it 'is private' do
      expect { store.add_customer(Customers.new('1', 'Bob', 1)) }.to raise_error(NoMethodError)
    end
  end
end
