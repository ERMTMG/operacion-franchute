extends Node
@export var playing: bool
var instruments: Array 
func _ready():
	instruments = [$Chords, $FillLead, $Guitar, $Hits, $Strings, $Subbass, $Trombones]

func _physics_process(delta):
	if !playing:
		$Base.stop()
		for instrument in instruments:
			instrument.stop()
	else:
		if $loop.time_left == 0 and !$Base.playing:
			play_music()

func play_music():
	$Base.play()
	for instrument in instruments:
		if randi() % 2 == 0:
			instrument.play()

func _on_loop_timeout():
	if playing:
		play_music()
