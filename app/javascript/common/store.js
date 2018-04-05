import store from 'store';
import eventsPlugin from 'store/plugins/events';
store.addPlugin(eventsPlugin)

if(!window.store) {
  window.store = store;
}

export default window.store;
