class Items
  attr_reader :items
  public :items

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
        price: 200
      }
    ]
  end

  def get_item(name:)
    @items.detect { |item| item[:name] == name }
  end
end
