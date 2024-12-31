# Background Class
class_name SceneBackground

extends Object  

var music: AudioStream
var art: VideoStream

func _init(music: AudioStream, art: VideoStream):
	self.music = music
	self.art = art
