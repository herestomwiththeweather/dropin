// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import { application } from "./application"

import BoardController from "./board_controller.js"
application.register("board", BoardController)

import HelloController from "./hello_controller.js"
application.register("hello", HelloController)

import ModalController from "./modal_controller.js"
application.register("modal", ModalController)

import TurboController from "./turbo_controller.js"
application.register("turbo", TurboController)
