FactoryBot.define do
  factory :client do
    sequence(:company) {|c| "Company#{c}"}
  end
end
