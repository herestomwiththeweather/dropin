class Person < ApplicationRecord
  has_many :registrations
  has_many :events, through: :registrations

  validates :identifier, presence: true, uniqueness: true

  def to_param
    identifier
  end
end
