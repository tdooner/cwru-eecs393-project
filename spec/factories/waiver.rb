FactoryGirl.define do
  factory :waiver do
    date_signed   { Date.parse('2012-01-01') }
    date_of_birth { Date.parse('1991-01-01') }
    emergency_name    'John Doe'
    emergency_phone   '123-456-7890'
  end
end
