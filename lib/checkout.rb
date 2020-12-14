require 'items'

# Public: Various methods used to scan/add items to a basket
# and calculate total cost of basket.
class Checkout
  # Public: Initialize checkout
  def initialize
    @basket = Array.new
    @items = Items.new
  end

  # Public: Add item to basket.
  #
  # item - Item name to be added to basket.
  def scan(item)
    begin
      # Check if one of item is already in basket
      existing_item_key = @basket.index { |basket_item| basket_item[:name] == item }

      # If not an existing item, create new item in basket
      if existing_item_key.nil?
        # Get item from data store by name
        item_hash = @items.get_item(name: item)

        # If item not found, raise an error
        if item_hash.nil?
          raise IOError.new 'Item not found.'
        else
          # Else set the item count in the basket and push to basket array
          item_hash[:count] = 1
          @basket << item_hash
        end
      else
        # If existing item, increment the item's count in the basket
        @basket[existing_item_key][:count] = @basket[existing_item_key][:count] + 1
      end
    rescue IOError => e
      e
    end
  end

  # Public: Calculate total price of items in the basket,
  # determining if item should have discount applied.
  #
  # Returns the basket total.
  def total
    total = 0

    # Loop through basket items, apply discount and sum total.
    @basket.each do |item|
      total += apply_discount(item)
    end

    total
  end

  # Public: Get basket contents
  #
  # Returns immutable basket contents.
  def basket
    @basket.freeze
  end

  private

  # Internal: Apply discount to item where applicable.
  #
  # item - Item hash
  #
  # Returns the item total after applying discount.
  def apply_discount(item)
    item_total = 0

    # Check if item has discount set in data store
    has_discount = item.key?(:discount) && item[:discount].key?(:type)

    # If item has discount, determine type and call appropriate discount method
    if has_discount
      case item[:discount][:type]
      when 'two_for_one'
        item_total += two_for_one(item[:price], item[:count])
      when 'half_price'
        item_total += half_price(item[:price], item[:count], one_per_customer: item[:discount][:one_per_customer])
      when 'buy_three_get_one_free'
        item_total += buy_three_get_one_free(item[:price], item[:count])
      end
    else
      # Otherwise, calculate item total without discount
      item_total += item[:price] * item[:count]
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
    # Calculate modulus, in this case either 0/1
    discount_modulus = count % 2

    # Half the count of only whole pairs of item
    discounted_count = (count - discount_modulus) / 2

    # Add the modulus back to give the discounted, adjusted count
    count_after_discount = discounted_count + discount_modulus

    item_price * count_after_discount
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

    # If one_per_customer flag true only apply half price to one item of type
    if one_per_customer
      price = item_price / 2
      price += item_price * (count - 1)
    else
      # Otherwise apply discount to all items of type
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
    # Adjust count by removing one item from count for every for purchased
    discounted_count = count - (count / 4)

    item_price * discounted_count
  end
end
