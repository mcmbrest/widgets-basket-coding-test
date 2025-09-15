products = [
  { name: "Red Widget",   code: "R01", price: 32.95 },
  { name: "Green Widget", code: "G01", price: 24.95 },
  { name: "Blue Widget",  code: "B01", price: 7.95 }
]

products.each do |product|
  Product.create!(**product)
end
