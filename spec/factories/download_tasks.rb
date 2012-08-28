# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :download_task do
    jail_id 1
    booking_id "MyString"
    is_downloaded false
    is_processed false
    remote_filename "MyString"
    local_filename "MyString"
  end
end
