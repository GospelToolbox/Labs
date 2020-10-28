module.exports = class LaunchPad {
  constructor(navigator) {
    this.navigator = navigator;
    this.keyDownHandlers = [];
    this.keyUpHandlers = [];
    this.connectHandlers = [];
  }

  connect() {
    this.navigator.requestMIDIAccess()
      .then(this.onMIDISuccess.bind(this), this.onMIDIFailure.bind(this));
  }

  onKeyDown(fn) {
    this.keyDownHandlers.push(fn);
  }

  onConnect(fn) {
    this.connectHandlers.push(fn);
  }

  onMIDISuccess(midiAccess) {
    console.log("MIDI Success!", midiAccess);

    midiAccess.onstatechange = this.onMIDIStateChange.bind(this)
    
    this.midiAccess = midiAccess;
    this.configure();
  }

  onMIDIFailure() {
    console.log('Could not access your MIDI devices.');
  }

  onMIDIStateChange(e) {
    console.log('MIDI state change: ', e.port.name, e.port.connection, e.port.type, e.port.state, e);

    this.configure();
  }

  configure() {
    this.launchpadOut = this.extractLaunchpadIO(this.midiAccess.outputs.values());
    this.launchpadIn = this.extractLaunchpadIO(this.midiAccess.inputs.values());

    if(this.launchpadIn) {
      this.launchpadIn.onmidimessage = this.getMIDIMessage.bind(this);
    }

    if(this.launchpadOut) {
      this.connectHandlers.forEach(function(handler) {
        handler();
      });
    }
  }

  setColor(x,y,color) {
    x = Math.max(0, Math.min(8, x));
    y = Math.max(0, Math.min(8, y));

    if (this.launchpadOut) {
      this.launchpadOut.send([144, this.keyFromCoords(x,y), color]);
    }
  }

  extractLaunchpadIO(items) {
    var item = items.next();
    while (!item.done) {
        if (item.value.name.indexOf('Launchpad') >= 0) {
            return item.value;
        }
        item = items.next();
    }
    return undefined;
  }

  getMIDIMessage(midiMessage) {
    let [ code, key, value ] = midiMessage.data;

    if(value == 0) {
      this.keyUp(key);
    } else if (value == 127) {
      this.keyDown(key);
    }
  }

  keyUp(key) {
    let coords = this.coordsFromKey(key)

    this.keyUpHandlers.forEach(function(handler) {
      handler(coords[0], coords[1]);
    });
  }

  keyDown(key) {
    let coords = this.coordsFromKey(key)

    this.keyDownHandlers.forEach(function(handler) {
      handler(coords[0], coords[1]);
    });
  }

  coordsFromKey(key) {
    let x = (key % 10) - 1;
    let y = (key - x - 1) / 10 - 1;
    return [ x, y ];
  }

  keyFromCoords(x, y) {
    return 11 + (10 * y) + x;
  }
}