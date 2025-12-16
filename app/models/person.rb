class Person < ApplicationRecord
  has_many :registrations
  has_many :events, through: :registrations
  belongs_to :client

  validates :identifier, presence: true, uniqueness: { scope: :client_id }

  def to_param
    identifier
  end

  def short_name
    name[0..name.index(' ')+1].concat('.')
  end

  def name_with_age
    "#{name} (#{age || 0})"
  end

  def age
    return nil if birthdate_at.nil?

    now = Time.current
    age = now.year - birthdate_at.year
    age -= 1 if now.month < birthdate_at.month || (now.month == birthdate_at.month && now.day < birthdate_at.day)
    age
  end
end
