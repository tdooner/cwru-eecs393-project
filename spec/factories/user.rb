FactoryGirl.define do
  factory :user do
    name          'Tom Dooner'
    email         'tom@tom.com'
    image_url     'http://google.com/image.png'
    auth_provider 'facebook'
    auth_uid      '1234567890'
  end
end
