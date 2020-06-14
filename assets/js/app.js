// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import "../css/app.scss"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import deps with the dep name or local files with a relative path, for example:
//
//     import {Socket} from "phoenix"
//     import socket from "./socket"
//
import "phoenix_html"
import {Socket} from "phoenix"
import NProgress from "nprogress"
import {LiveSocket} from "phoenix_live_view"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {params: {_csrf_token: csrfToken}})

// Show progress bar on live navigation and form submits
window.addEventListener("phx:page-loading-start", info => NProgress.start())
window.addEventListener("phx:page-loading-stop", info => NProgress.done())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)
window.liveSocket = liveSocket

function setupTimezoneSelect() {
  const elem = document.getElementById("tz-select")
  elem.onchange = function() {
    const tz = this.value
    const url = window.location.href.split("?")[0]
    window.location.replace(url + "?tz=" + tz)
  }
}

function scrollToActive() {
  const lives = document.getElementsByClassName("live-active")

  if (lives.length > 0) {
    lives[0].scrollIntoView({ behavior: "smooth" })
  }
}

window.onload = () => {
  setupTimezoneSelect()
  scrollToActive()
}
