class Registration < ApplicationRecord
  belongs_to :event
  belongs_to :person

  validates :event, presence: true
  validates :person, presence: true, uniqueness: { scope: :event_id }

  after_create_commit -> do
    broadcast_append_later_to(event, :registrations, target: "event_#{event.id}-registrations")
  end
end
