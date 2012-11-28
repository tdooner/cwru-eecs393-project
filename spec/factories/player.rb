FactoryGirl.define do
  factory :player do
    registered  true
    off_campus  false
    game_admin  false
    points      { Random.rand(50000) }

    game
    user
  end
end
