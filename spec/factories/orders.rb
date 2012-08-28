# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :order do
    booking_id 1
    first_name "MyString"
    last_name "MyString"
    card_type "MyString"
    card_expires_on "2012-07-09"
    remote_ip "MyString"
  end
end
