var componentRequireContext = require.context("components", true)
var ReactRailsUJS = require("react_ujs")
ReactRailsUJS.useContext(componentRequireContext)
ReactRailsUJS.removeEvent('DOMContentLoaded', ReactRailsUJS.handleMount);
ReactRailsUJS.removeEvent('onload', ReactRailsUJS.handleMount);
document.addEventListener("DOMContentLoaded", function(event) {
  ReactRailsUJS.mountComponents(".navbar")
});