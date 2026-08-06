function lovr.conf(t)
	-- Set the project version and identity
	t.version = "0.19.0"
	t.identity = "ThreadEngine"

	-- Set save directory precedence
	t.saveprecedence = true

	-- Enable or disable different modules
	t.modules.audio = true
	t.modules.data = true
	t.modules.event = true
	t.modules.graphics = true
	t.modules.headset = false
	t.modules.math = true
	t.modules.physics = true
	t.modules.system = true
	t.modules.thread = true
	t.modules.timer = true

	-- Audio
	t.audio.debug = false
	t.audio.samplerate = 48000
	t.audio.start = true
	t.audio.reverb.type = "convolution"
	t.audio.reverb.rays = 4096
	t.audio.reverb.bounces = 4
	t.audio.reverb.duration = 2
	t.audio.reverb.rate = 0.1

	-- Graphics
	t.graphics.debug = false
	t.graphics.vsync = true
	t.graphics.stencil = true
	t.graphics.antialias = true
	t.graphics.shadercache = true

	-- Headset settings
	t.headset = nil

	-- Math settings
	t.math.globals = true

	-- Thread settings
	t.thread.workers = -1

	-- Configure the desktop window
	t.window = nil
end