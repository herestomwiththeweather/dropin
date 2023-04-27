import { Controller } from "@hotwired/stimulus"
import { createConsumer, Channel } from "@rails/actioncable"

// Connects to data-controller="board"
export default class extends Controller {

  static values = { start: Number, clientid: Number }
  static targets = ['form']

  connect() {
    console.log('xxx hello')
    if(this.channel) {
      return
    }
    this.channel = this.createChannel(this)
  }

  createChannel(source) {
     createConsumer().subscriptions.create("BoardChannel", {
      connected() {
        // Called when the subscription is ready for use on the server
        let timeoutId = null
        document.board_client = this
        document.board_clientid = source.clientidValue
        timeoutId = setInterval(source.upcoming, 300000)
      },

      disconnected() {
        // Called when the subscription has been terminated by the server
      },

      received(data) {
        // Called when there's incoming data on the websocket for this channel
        console.log(data)
        if(data.start_at > source.startValue) {
          console.log('XXX loading new event')
          document.getElementById('event_identifier').value = data.event_id
          source.startValue = data.start_at // bump current start time for future comparisons
          source.formTarget.requestSubmit()
        } else {
          console.log('XXX NOT loading new event')
        }
      },
    })
  }

  upcoming() {
    console.log('XXX upcoming()')
    document.board_client.perform("upcoming_event", {stored_start_at: 0, client_id: document.board_clientid})
  }
}
