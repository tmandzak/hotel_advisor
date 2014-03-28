FactoryGirl.define do

  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}
    password "foobar"
    password_confirmation "foobar"
    
    factory :admin do
      admin true
    end

  end

  factory :hotel do
    sequence(:title) { |n| "Hotel-#{n}" }
    stars 5
    rate_avg 4.5
    breakfast true
    description 'Some description'
    price 1000.0
    photo 'photo.jpg'
    approved false
    address
  end

  factory :address do
    country 'Ukraine'
    state 'LV'
    city 'Lviv'
    street 'Svobody, 1'
  end
  
  factory :rate do
    rate 5
    comment "Some comment"
    user
    hotel
  end



end




