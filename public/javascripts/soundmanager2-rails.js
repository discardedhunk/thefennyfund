sound_manager_currently_playing = null;

function toggle_sound(id) {
  soundManager.stopAll();
  
  if(sound_manager_currently_playing != null) {
    Element.update(sound_manager_currently_playing, '<img alt="Play" border="0" src="/images/SoundManager2/play-control.gif"/>');
  }
  
  if(sound_manager_currently_playing == id) {
    sound_manager_currently_playing = null;
  }
  else {
    soundManager.play(id);
    sound_manager_currently_playing = id;
    Element.update(sound_manager_currently_playing, '<img alt="Pause" border="0" src="/images/SoundManager2/pause-control.gif"/>');
    setTimeout("toggle_sound(sound_manager_currently_playing)", 30000);
    //setTimeout("Element.update(sound_manager_currently_playing, \'<img alt=\"Pause\" border=\"0\" src=\"/images/SoundManager2/play-control.gif\"/>\')", 31000);
    //LJK: this should be stop, not pause!
    
  }
}