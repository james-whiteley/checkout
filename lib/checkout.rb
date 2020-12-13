require 'items'

# Public: Various methods used to scan/add items to a basket
# and calculate total cost of basket.
class Checkout
  # Public: Initialize item prices.
  #
  # prices - A hash of item prices.
  def initialize
    @items = Items.new
  end

  # Public: Add item to basket.
  #
  # item - Item name to be added to basket.
  def scan(item)
    basket << item
  end

  # Public: Calculate total price of items in the basket,
  # determining if item should have discount applied.
  #
  # Returns the basket total.
  def total
    total = 0
    item_counts = basket.inject(Hash.new(0)) { |items, item| items[item] += 1; items }

    item_counts.each do |item, count|
      total += apply_discount(item, count)
    end

    total
  end

  private

  # Internal: Get basket array or initialise if does not exist
  #
  # Returns the array of items in the basket.
  def basket
    @basket ||= Array.new
  end

  # Internal: Apply discount to item where applicable.
  #
  # item_price - Item price
  # count - Count of item in basket
  #
  # Returns the item total after applying discount.
  def apply_discount(item, count)
    item_total = 0
    item_hash = @items.get_item(name: item.to_s)

    if item_hash.key?(:discount) && item_hash[:discount].key?(:type)
      case item_hash[:discount][:type]
      when 'two_for_one'
        item_total += two_for_one(item_hash[:price], count)
      when 'half_price'
        item_total += half_price(item_hash[:price], count, one_per_customer: item_hash[:discount][:one_per_customer])
      when 'buy_three_get_one_free'
        item_total += buy_three_get_one_free(item_hash[:price], count)
      end
    else
      item_total += item_hash[:price] * count
    end

    item_total
  end

  # Internal: Apply two for one discount to price of item in basket.
  #
  # item_price - Item price
  # count - Count of item in basket
  #
  # Returns total item price after discount applied.
  def two_for_one(item_price, count)
    price = 0

    if (count % 2 == 0)
      price = item_price * (count / 2)
    else
      price = item_price * count
    end

    price
  end

  # Internal: Apply half price discount to price of item in basket.
  #
  # item_price - Item price
  # count - Count of item in basket
  # one_per_customer - True/False apply discount to one/all of particular item in basket
  #
  # Returns total item price after discount applied.
  def half_price(item_price, count, one_per_customer: false)
    price = 0

    if one_per_customer
      price = item_price / 2
      price += item_price * (count - 1)
    else
      price = (item_price / 2) * count
    end

    price
  end

  # Internal: Apply buy three get one free discount to price of item in basket.
  #
  # item_price - Item price
  # count - Count of item in basket
  #
  # Returns total item price after discount applied.
  def buy_three_get_one_free(item_price, count)
    price = 0

    if (count % 4 == 0)
      price = item_price * (count - 1)
    else
      price = item_price * count
    end

    price
  end
end
