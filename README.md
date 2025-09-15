# README

Check the `app/services` folder for the business logic.

**Creating a basket**

Specify the delivery provider and the list of offer codes when creating a basket. But you can add offers later also. 
```ruby
basket = Basket.new(delivery_provider: 'default', offers: ['rhp'])
```

**Adding items**
- Add items by product code: `basket.add_item('R01')`.
- Quantities increase automatically if the same product is added multiple times.

**Delivery providers**
- The system supports only two delivery providers
  - `default` → tiered delivery pricing:
    - Subtotal < 50.00 → 4.95
    - 50.00 ≤ Subtotal < 90.00 → 2.95
    - Subtotal ≥ 90.00 → 0.00
  - `pickup` → free delivery: 0.00
- Delivery is calculated on the discounted subtotal (sum of `basket_amount`s).

**Offers**
- The system currently recognizes only one offer
  - `rhp` → Red Second Half Price:
    - For product code `R01` (Red Widget): every second unit is half price.

**Example session**
```ruby
basket = Basket.new(delivery_provider: 'default', offers: ['rhp'])
basket.add_item('B01')
basket.add_item('G01')
puts basket.total.to_f 
=> 37.85 
```
