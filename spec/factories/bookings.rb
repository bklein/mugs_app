# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :booking, :class => 'Bookings' do |f|
    
    sequence(:booking_no){|n| "ASO000000#{n}"}
    
  	sequence(:inmate_name) { Faker::Name.name }
		f.booking_datetime Time.now
		f.bond  "10000"
		f.mugshot {File.open(Rails.root.join("spec", "files", "avatar_1.jpg"))}
  end
end
