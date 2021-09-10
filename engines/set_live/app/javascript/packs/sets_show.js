import "core-js/stable";
import "regenerator-runtime/runtime";

import Metronome from "metronome";
import Launchpad from "launchpad";

// Entrypoint
window.addEventListener('load', init, false);
function init() {
  loadAudioContext();

  setupBpmAdjustments();
  loadClickBuffer();
  loadPadBuffers();

  connectLaunchpad();

  $('#btn_stop_all').click(function() {
    stopAllPads();
    metronome.stop();
  });

  $('#btn_stop_click').click(function() {
    metronome.stop();
  });

  $('#btn_prev').click(function() {
    prevSong();
  })

  $('#btn_next').click(function() {
    nextSong();
  });
}

var audioContext;
var metronome;
var launchpad;
var clickBuffer;
var padBuffers = {};
var padsToLoad = 0;
var padSources = {};
var padGains = {};
var currentSongNdx = 0;

function loadAudioContext() {
  // Fix up for prefixing
  window.AudioContext = window.AudioContext || window.webkitAudioContext;
  audioContext = new AudioContext();
}

function setupBpmAdjustments() {
  data.songs.forEach(function(song) {
    let num_bpm = $('#num_bpm_' + song.id)
    num_bpm.change(function() {
      song.bpm = num_bpm.val();
      metronome.tempo = song.bpm;
    });
  });
}

function loadClickBuffer() {  
  loadBuffer('https://gtbox-setlive.s3.amazonaws.com/Metronome.wav', function (buffer) {
    metronome = new Metronome(84, buffer, audioContext);
  });
}

function loadPadBuffers() {
  function onlyUnique(value, index, self) { 
    return self.indexOf(value) === index;
  }   

  var keys = data.songs.map(function(s) { return s.key; })
                   .filter(onlyUnique);
  padsToLoad = keys.length;

  keys.forEach(function(key) {
      let ids = data.songs.filter(function(song) { return song.key == key; })
                      .map(function(song) { return song.id; });

      ids.forEach(function(id) {
        $('#' + id + '_pad_loading_status').text('Loading...');
      });

      padsToLoad--;

      ids.forEach(function(id) {
        $('#' + id + '_pad_loading_status').text('');
        onPadLoaded(id, key);
      });

      // loadBuffer('https://gtbox-setlive.s3.amazonaws.com/Key_of_' + encodeURIComponent(key) + '_Pads_5.mp3', function (buffer) {
      //   padBuffers[key] = buffer;
      //   padsToLoad--;

      //   ids.forEach(function(id) {
      //     $('#' + id + '_pad_loading_status').text('');
      //     onPadLoaded(id, key);
      //   });
      // });
    });
  }

  function onPadLoaded(id, key) {

    $('#play_btn_'+id).click(function() {
      var idx = data.songs.findIndex(function(song) {
        return song.id == id;
      });
      startMaster(idx);
      currentSongNdx = idx;
    });

    $('#mute_pad_'+id).click(function() {
        padGains[id].gain.setValueAtTime(padGains[id].gain.value, audioContext.currentTime);
        padGains[id].gain.exponentialRampToValueAtTime(1 - padGains[id].gain.value, audioContext.currentTime + 1  );
    });
  }

  function stopAllPads() {
    var padSources = document.querySelectorAll('audio.pads');

    padSources.forEach(function(source) {
      source.pause();
    })
    // for(var source in padSources) {
    //   source.pause()
    //   // if(padSources[prop]) {
    //   //   padGains[prop].gain.setValueAtTime(padGains[prop].gain.value, audioContext.currentTime);
    //   //   padGains[prop].gain.linearRampToValueAtTime(0.001, audioContext.currentTime + 2  );
    //   //   padSources[prop].stop(audioContext.currentTime + 2);
    //   // }
    // }
  }
  

  function loadBuffer(url, setter) {
    var request = new XMLHttpRequest();
    request.open('GET', url, true);
    request.responseType = 'arraybuffer';

    // Decode asynchronously
    request.onload = function () {
      audioContext.decodeAudioData(request.response, setter, function (err) {
        console.error('Failed to load audio file', err);
      });
    }
    request.send();
  }

  function playBuffer(buffer, time, pan) {
    // var source = audioContext.createBufferSource(); // creates a sound source
    // source.buffer = buffer; // tell the source which sound to play

    var source = audioContext.createMediaElementSource(buffer)

    var panNode = audioContext.createStereoPanner();
    panNode.pan.setValueAtTime(pan, time);

    var gainNode = audioContext.createGain();
    gainNode.gain.setValueAtTime(0.99999, time);

    source.connect(gainNode); // connect the source to the context's destination (the speakers)
    gainNode.connect(panNode);
    panNode.connect(audioContext.destination);

    buffer.currentTime = 0;
    buffer.play();

    return [source, gainNode];
  }

  function toggleMetronome() {
    if(metronome.playing) {
      metronome.stop();
    } else {
      metronome.start();
    }
  }

  function prevSong() {
    // Make sure we're not at the first song
    if(currentSongNdx == 0) {
      return;
    }

    currentSongNdx--;
    startMaster(currentSongNdx);
  }

  function nextSong() {
    if(currentSongNdx == data.songs.length - 1) {
      return;
    }

    currentSongNdx++;
    startMaster(currentSongNdx);
  }

  function startMaster(ndx) {

    resetLaunchpadColors();
    if(ndx < 8) {
      launchpad.setColor(6, 7-ndx, 122);
      launchpad.setColor(7, 7-ndx, 122);
      launchpad.setColor(8, 7-ndx, 122);
    }

    var song = data.songs[ndx];

    stopAllPads();

    var audioElement = document.querySelector('audio#audio_' + song.id)
    var response = playBuffer(audioElement, audioContext.currentTime, 1);
    padSources[song.id] = response[0];
    padGains[song.id] = response[1];

    metronome.tempo = song.bpm;
    metronome.start();
  }

  function connectLaunchpad() {
    launchpad = new Launchpad(navigator);

    launchpad.onConnect(function() {
      resetLaunchpadColors();
    });
    launchpad.connect();

    launchpad.onKeyDown(function(x,y) {
      var idx = 7-y;

      if (x == 0 && y == 0) {
        prevSong();
        return;
      } else if (x == 2 && y == 0) {
        nextSong();
        return;
      }

      var song = data.songs[idx];
      if (song) {
        var id = song.id;

        switch (x) {
          case 6: // Toggle pad
            if(padGains[id]) {
              padGains[id].gain.setValueAtTime(padGains[id].gain.value, audioContext.currentTime);
              padGains[id].gain.exponentialRampToValueAtTime(1 - padGains[id].gain.value, audioContext.currentTime + 1  );
            }
          break;

          case 7: // Toggle click
            toggleMetronome();
          break;

          case 8: // Toggle master
            currentSongNdx = idx;
            startMaster(idx);
          break;
        
          default:
            break;
        }
      }
    });
    
  }

  function resetLaunchpadColors() {
    clearLaunchpadColors();

    // Prev and Next buttons
    launchpad.setColor(0,0, 67);
    launchpad.setColor(2,0, 67);

    for(var i = 0; i < data.songs.length; i++) {
      var y = 7-i;

      // Color midi toggle
      launchpad.setColor(6, y, 67);

      // Color click toggle
      launchpad.setColor(7, y, 107);

      // Color master toggle
      launchpad.setColor(8, y, 40);
    }
  }

  function clearLaunchpadColors() {
    for(var i = 0; i < 9; i++) {
      for(var j = 0; i < 8; i++) {

      // Color midi toggle
      launchpad.setColor(i, j, 0);
    }
  }
}