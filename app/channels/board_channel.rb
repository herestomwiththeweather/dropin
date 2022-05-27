class BoardChannel < ApplicationCable::Channel
  def subscribed
    Rails.logger.info "XXX BoardChannel#subscribed"
    stream_from "board"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def upcoming_event(payload)
    Rails.logger.info "XXX BoardChannel#upcoming_event #{payload['stored_start_at']}"
    event, next_event = Event::upcoming_events
    event.board_refresh
    next_event.board_refresh
    ActionCable.server.broadcast "board", { event_id: event.id, start_at: event.start_at.to_i }
  end
end
