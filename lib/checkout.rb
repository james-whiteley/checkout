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
  # item  - Item name to be added to basket.
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
      if item == :apple || item == :pear
        if (count % 2 == 0)
          total += prices.fetch(item) * (count / 2)
        else
          total += prices.fetch(item) * count
        end
      elsif item == :banana || item == :pineapple
        if item == :pineapple
          total += (prices.fetch(item) / 2)
          total += (prices.fetch(item)) * (count - 1)
        else
          total += (prices.fetch(item) / 2) * count
        end
      else
        total += prices.fetch(item) * count
      end
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
end
