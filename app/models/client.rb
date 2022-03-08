require 'uri'
require 'cgi'
require 'net/https'

DASH_BASE_URL = 'https://api.dashplatform.com'
DASH_VERSION = 'v1'

class Client < ApplicationRecord
  has_many :access_tokens

  def get_token
    u = URI.parse(DASH_BASE_URL)
    http = ::Net::HTTP.new(u.host, u.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    body = {
      :client_id => CGI::escape(identifier),
      :client_secret => CGI::escape(secret),
      :grant_type => 'client_credentials',
      :user_type => 'company'
    }.to_json
    response = http.post("/#{DASH_VERSION}/auth/token?company=#{company}", body, "Content-Type": "application/json\r\n")
    access_token = JSON.parse(response.body)['access_token']
    access_tokens.create!(token: access_token)
    access_token
  end

  def access_token
    access_tokens.order('created_at DESC').first
  end

  def request(path)
    u = URI.parse("#{DASH_BASE_URL}/#{DASH_VERSION}/#{path}")
    http = ::Net::HTTP.new(u.host, u.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    req = ::Net::HTTP::Get.new(u.request_uri)
    req['Authorization'] = "Bearer #{access_token.token}"
    response = http.request(req)
  end

  def get_event(event_id)
    get_token if (access_token.nil? || access_token.expired?)
    request("events/#{event_id}?company=#{company}&include=registrants")
  end

  def get_people(event_id)
    e = get_event(event_id)
    event = JSON.parse(e.body)
    nil == event['included'] ? [] : event['included'].map {|person| person['attributes']['full_name']}
  end

  def get_players
    players_event_id = Event.upcoming_event_id_by_category(Event::PLAYERS)
    if nil == players_event_id
      []
    else
      get_people(players_event_id)
    end
  end

  def get_goalies
    goalies_event_id = Event.upcoming_event_id_by_category(Event::GOALIES)
    if nil == goalies_event_id
      []
    else
      get_people(goalies_event_id)
    end
  end
end
