namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    User.create!(name: "Taras Mandzak",
                 email: "tmandzak@gmail.com",
                 password: "password",
                 password_confirmation: "password")
    

    5.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@example.org"
      password  = "password"
      User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password)
    end


    users = User.first(6)

    rg = Random.new
    
    50.times do
      hotel = Hotel.new(title: Faker::Company.name + " Hotel",
                        stars: rg.rand(5),
                        breakfast: rg.rand(2) == 1,
                        description: Faker::Lorem.paragraph,
                        price: rg.rand(200..2000))

      hotel.user = users[rg.rand(5)]
      hotel.build_address(country: Faker::Address.country,
                             city: Faker::Address.city,
                            state: Faker::Address.state_abbr, 
                           street: Faker::Address.street_address)
      hotel.save

      rates_number = rg.rand(1..10)

      rates_number.times do
        hotel_rate = rg.rand(1..5)
        rate = hotel.rates.build(rate: hotel_rate, comment: Faker::Lorem.sentence)
        rate.user = users[rg.rand(5)]
        rate.save

        hotel.rates_total += hotel_rate;
      end

      hotel.rate_avg = hotel.rates_total.to_f / rates_number;
      hotel.save

    end  
     

  end
end