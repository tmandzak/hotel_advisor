FactoryGirl.define do

  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}
    password "foobar"
    password_confirmation "foobar"

  end

  factory :hotel do

  end
  
  factory :rate do
    rate 5
    comment "Some comment"
    user
    hotel
  end 

end