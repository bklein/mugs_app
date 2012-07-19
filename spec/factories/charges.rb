# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :charge, :class => 'Charges' do |c|
    sequence(:charge_name) {|n| "#{Faker::Company.catch_phrase}"}
  	
  end
end
