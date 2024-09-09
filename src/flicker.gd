extends OmniLight3D

@export var noise: NoiseTexture3D

var time = 0.0

func _process(delta):
	time += delta

	light_energy = abs(noise.noise.get_noise_1d(time))
