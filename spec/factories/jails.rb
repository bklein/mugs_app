# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :jail, :class => 'Jails' do |j|
    sequence(:short_name) {|n| "county_jail_#{n}"}
    sequence(:full_name) {|n| "County Jail #{n}"}
    
  end
end
