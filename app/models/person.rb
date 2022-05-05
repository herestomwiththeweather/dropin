class Person < ApplicationRecord
  has_many :registrations
  has_many :events, through: :registrations

  validates :identifier, presence: true, uniqueness: true

  def to_param
    identifier
  end

  def short_name
    name[0..name.index(' ')+1].concat('.')
  end
end
