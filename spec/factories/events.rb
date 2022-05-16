FactoryBot.define do
  factory :event do
    identifier { 1 }
    start_at { "2022-05-16 13:26:12" }
    category { 1 }
    last_fetched_at { "2022-05-16 13:26:12" }
  end
end
