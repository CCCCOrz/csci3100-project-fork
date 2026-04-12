# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

Item.destroy_all
User.destroy_all

users = User.create!([
  {
    name: "agnes",
    email: "agnes@link.cuhk.edu.hk",
    password: "password123",
    password_confirmation: "password123",
    location: "New Asia College",
    created_at: Time.current
  },
  {
    name: "ben",
    email: "ben@link.cuhk.edu.hk",
    password: "password123",
    password_confirmation: "password123",
    location: "United College",
    created_at: Time.current
  },
  {
    name: "cathy",
    email: "cathy@link.cuhk.edu.hk",
    password: "password123",
    password_confirmation: "password123",
    location: "Shaw College",
    created_at: Time.current
  },
  {
    name: "daniel",
    email: "daniel@link.cuhk.edu.hk",
    password: "password123",
    password_confirmation: "password123",
    location: "Morningside College",
    created_at: Time.current
  },
  {
    name: "eva",
    email: "eva@link.cuhk.edu.hk",
    password: "password123",
    password_confirmation: "password123",
    location: "S.H. Ho College",
    created_at: Time.current
  }
])

items = [
  {
    name: "MacBook Pro 14",
    description: "512GB storage, great for coding assignments and FYP demos.",
    price: 8800,
    post_date: "2026-04-06",
    status: "available",
    category: "electronics",
    seller_id: users[0].id,
    image_path: "app/assets/images/macbook.jpeg"
  },
  {
    name: "MacBook Air M2",
    description: "Lightweight laptop, battery still healthy, includes charger.",
    price: 6200,
    post_date: "2026-04-01",
    status: "reserved",
    category: "electronics",
    seller_id: users[1].id,
    image_path: "app/assets/images/macbook.jpeg"
  },
  {
    name: "iPhone 13",
    description: "Blue phone in good condition, 128GB, ideal for daily use.",
    price: 2600,
    post_date: "2026-04-03",
    status: "reserved",
    category: "electronics",
    seller_id: users[0].id,
    image_path: "app/assets/images/macbook.jpeg"
  },
  {
    name: "iPhone 13 Pro",
    description: "Sierra blue, 256GB, camera and face ID working perfectly.",
    price: 3400,
    post_date: "2026-04-02",
    status: "available",
    category: "electronics",
    seller_id: users[2].id,
    image_path: "app/assets/images/macbook.jpeg"
  },
  {
    name: "iPad Pro",
    description: "Great tablet for note taking, comes with magnetic case.",
    price: 4200,
    post_date: "2026-04-01",
    status: "available",
    category: "electronics",
    seller_id: users[0].id,
    image_path: "app/assets/images/macbook.jpeg"
  },
  {
    name: "Microeconomics Textbook",
    description: "Helpful for ECON students, some highlights inside.",
    price: 180,
    post_date: "2026-04-02",
    status: "sold",
    category: "books",
    seller_id: users[1].id,
    image_path: "app/assets/images/novel.jpeg"
  },
  {
    name: "Bicycle",
    description: "Latest design, easy pick-up near hostel bike rack.",
    price: 500,
    post_date: "2026-03-28",
    status: "available",
    category: "sports",
    seller_id: users[0].id,
    image_path: "app/assets/images/bicycle.jpeg"
  },
  {
    name: "Guitar",
    description: "YAMAHA brand acoustic guitar, suitable for hostel jamming.",
    price: 1200,
    post_date: "2026-03-15",
    status: "available",
    category: "other",
    seller_id: users[1].id,
    image_path: "app/assets/images/guitar.jpeg"
  },
  {
    name: "Lamp",
    description: "LED and eye-protective desk lamp for late night revision.",
    price: 120,
    post_date: "2026-03-22",
    status: "available",
    category: "furniture",
    seller_id: users[2].id,
    image_path: "app/assets/images/lamp.jpeg"
  },
  {
    name: "Novel",
    description: "Nobel Prize winner novel, still in very good condition.",
    price: 40,
    post_date: "2026-02-25",
    status: "available",
    category: "books",
    seller_id: users[0].id,
    image_path: "app/assets/images/novel.jpeg"
  },
  {
    name: "Desk Lamp",
    description: "Warm white study lamp, compact enough for dorm desks.",
    price: 90,
    post_date: "2026-04-05",
    status: "available",
    category: "furniture",
    seller_id: users[1].id,
    image_path: "app/assets/images/lamp.jpeg"
  },
  {
    name: "Gaming Chair",
    description: "Ergonomic chair with adjustable back support and soft armrests.",
    price: 850,
    post_date: "2026-03-10",
    status: "available",
    category: "furniture",
    seller_id: users[2].id,
    image_path: "app/assets/images/lamp.jpeg"
  },
  {
    name: "Calculus Notes Bundle",
    description: "Handwritten notes plus tutorial solutions for MATH courses.",
    price: 70,
    post_date: "2026-04-04",
    status: "available",
    category: "books",
    seller_id: users[3].id,
    image_path: "app/assets/images/novel.jpeg"
  },
  {
    name: "Badminton Racket",
    description: "Well-kept racket with grip tape replaced recently.",
    price: 210,
    post_date: "2026-03-29",
    status: "reserved",
    category: "sports",
    seller_id: users[4].id,
    image_path: "app/assets/images/bicycle.jpeg"
  },
  {
    name: "Monitor 24 inch",
    description: "Perfect second screen for coding and report writing.",
    price: 780,
    post_date: "2026-04-04",
    status: "available",
    category: "electronics",
    seller_id: users[3].id,
    image_path: "app/assets/images/macbook.jpeg"
  }
]

items.each do |data|
  item = Item.create!(
    name: data[:name],
    description: data[:description],
    price: data[:price],
    post_date: data[:post_date],
    status: data[:status],
    category: data[:category],
    seller_id: data[:seller_id]
  )

  if File.exist?(data[:image_path])
    item.photo.attach(
      io: File.open(data[:image_path]),
      filename: File.basename(data[:image_path]),
      content_type: "image/jpeg"
    )
  else
    puts "Image not found: #{data[:image_path]}"
  end
end
