class BoardChannel < ApplicationCable::Channel
  def subscribed
    Rails.logger.info "XXX BoardChannel#subscribed"
    stream_from "board"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def upcoming_event(payload)
    if Event::DEFAULT_CLIENT_ID == payload['client_id']
      Rails.logger.info "BoardChannel#upcoming_event Client 1 calling Event::upcoming_events"
      event, next_event = Event::upcoming_events
    elsif Event::SECOND_CLIENT_ID == payload['client_id']
      Rails.logger.info "BoardChannel#upcoming_event Client 2 calling Event::bfree_events"
      event, next_event = Event::bfree_events
    else
      Rails.logger.info "BoardChannel#upcmoing_event Error. unsupported client id"
      return
    end
    event.board_refresh
    next_event.board_refresh
    ActionCable.server.broadcast "board", { event_id: event.id, client_id: event.client_id, start_at: event.start_at.to_i }
  end
end
