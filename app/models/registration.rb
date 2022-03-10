class Registration < ApplicationRecord
  belongs_to :event
  belongs_to :person

  validates :event, presence: true
  validates :person, presence: true, uniqueness: { scope: :event_id }
end
