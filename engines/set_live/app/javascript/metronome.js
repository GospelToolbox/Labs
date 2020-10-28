module.exports = class Metronome {
  constructor(tempo, buffer, audioContext) {
    this.tempo = tempo;
    this.buffer = buffer;
    this.audioContext = audioContext;

    this.lookahead = 25.0; // How frequently to call scheduling function 
                           //(in milliseconds)
    this.scheduleAheadTime = 0.1; // How far ahead to schedule audio (sec)
                                  // This is calculated from lookahead, and overlaps 
                                  // with next interval (in case the timer is late)
    this.nextNoteTime = 0.0;
    this.noteResolution = 1; // 0 == 16th, 1 == 8th, 2 == quarter note
    this.current16thNote = null;
    this.metronomeInterval = null;
  }

  get playing() {
    return this.metronomeInterval != null;
  }

  setTemp(bpm) {
    this.tempo = bpm;
  }

  start() {
    this.current16thNote = 0;
    this.nextNoteTime = this.audioContext.currentTime;

    this.stop();

    this.metronomeInterval = window.setInterval(this.scheduler.bind(this), this.lookahead);
  }

  stop() {
    if(this.metronomeInterval) {
      window.clearInterval(this.metronomeInterval);
      this.metronomeInterval = null;
    }
  }

  nextNote() {
    // Advance current note and time by a 16th note...
    let secondsPerBeat = 60.0 / this.tempo; // Notice this picks up the CURRENT 

    // tempo value to calculate beat length.
    this.nextNoteTime += 0.25 * secondsPerBeat; // Add beat length to last beat time

    this.current16thNote++; // Advance the beat number, wrap to zero
    if (this.current16thNote == 16) {
      this.current16thNote = 0;
    }
  }

  scheduleNote(beatNumber, time) {
    if ((this.noteResolution == 1) && (beatNumber % 2)) {
      return; // we're not playing non-8th 16th notes
    }

    if ((this.noteResolution == 2) && (beatNumber % 4)) {
      return; // we're not playing non-quarter 8th notes
    }

    this.playBuffer(this.buffer, time, -1);
  }

  scheduler() {
    // while there are notes that will need to play before the next interval, 
    // schedule them and advance the pointer.
    while (this.nextNoteTime < this.audioContext.currentTime + this.scheduleAheadTime) {
      this.scheduleNote(this.current16thNote, this.nextNoteTime);
      this.nextNote();
    }
  }

  playBuffer(buffer, time, pan) {
    let source = this.audioContext.createBufferSource(); // creates a sound source
    source.buffer = buffer; // tell the source which sound to play

    let panNode = this.audioContext.createStereoPanner();
    panNode.pan.setValueAtTime(pan, time);

    source.connect(panNode); // connect the source to the context's destination (the speakers)
    panNode.connect(this.audioContext.destination);

    source.start(time);
  }
}
