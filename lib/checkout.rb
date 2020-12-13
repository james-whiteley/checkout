# Public: Various methods used to scan/add items to a basket
# and calculate total cost of basket.
class Checkout
  # Internal: Returns the hash of item prices.
  attr_reader :prices
  private :prices

  # Public: Initialize item prices.
  #
  # prices - A hash of item prices.
  def initialize(prices)
    @prices = prices
  end

  # Public: Add item to basket.
  #
  # item - Item name to be added to basket.
  def scan(item)
    basket << item.to_sym
  end

  # Public: Calculate total price of items in the basket,
  # determining if item should have discount applied.
  #
  # Returns the basket total.
  def total
    total = 0

    basket.inject(Hash.new(0)) { |items, item| items[item] += 1; items }.each do |item, count|
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

    if item == :apple || item == :pear
      item_total += two_for_one(prices.fetch(item), count)
    elsif item == :banana || item == :pineapple
      item_total += half_price(prices.fetch(item), count, one_per_customer: item == :pineapple)
    else
      item_total += prices.fetch(item) * count
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
end
