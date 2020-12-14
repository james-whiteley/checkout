# Public: Wrapper for item array to simulate data storage
class Items
  # Public: Initialize items array
  def initialize
    @items = [
      {
        name: 'apple',
        price: 10,
        discount: {
          type: 'two_for_one',
          one_per_customer: false
        }
      },
      {
        name: 'orange',
        price: 20
      },
      {
        name: 'pear',
        price: 15,
        discount: {
          type: 'two_for_one',
          one_per_customer: false
        }
      },
      {
        name: 'banana',
        price: 30,
        discount: {
          type: 'half_price',
          one_per_customer: false
        }
      },
      {
        name: 'pineapple',
        price: 100,
        discount: {
          type: 'half_price',
          one_per_customer: true
        }
      },
      {
        name: 'mango',
        price: 200,
        discount: {
          type: 'buy_three_get_one_free'
        }
      }
    ]
  end

  # Public: Get item by name
  #
  # name - Name of item
  #
  # Returns item with given name if found in items array
  def get_item(name:)
    @items.detect { |item| item[:name] == name }
  end
end
