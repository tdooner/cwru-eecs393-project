FactoryGirl.define do
  factory :game do
    name                  'Spring 2012'
    registration_begins   DateTime.parse('2012-01-01 00:00:00')
    registration_ends     DateTime.parse('2012-01-04 00:00:00')
    game_begins           DateTime.parse('2012-01-05 00:00:00')
    game_ends             DateTime.parse('2012-01-05 00:00:00')
  end
end
