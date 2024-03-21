class AccessToken < ApplicationRecord
  belongs_to :client

  validates :token, presence: true

  def expired?
    decoded_token = JWT.decode self.token, nil, false
    Time.at(decoded_token[0]['exp']).to_datetime < Time.now.to_datetime
  end
end
