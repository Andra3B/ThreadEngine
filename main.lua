require("init")

function Thread.Load()
	cube = Body.Create()	
	light = PointLight.Create()

	fps = Label.Create()

	fps.Name = "FPS Label"

	fps.Size = ScaleOffset2.Create(0, 0, 150, 50)
	fps.HorizontalTextAlignment = Enum.HorizontalAlignment.Middle
	fps.VerticalTextAlignment = Enum.VerticalAlignment.Middle
	fps.CornerRadius = ScaleOffset4.Create(0, 0, 1, 0, 0, 0, 0, 0)
	fps.BackgroundColour = Vector4.Create(1, 1, 1, 0.8)

	cube.Position = Vector3.Create(0, 0, -3)
	light.Position = Vector3.Create(0, 2, 0)

	test = Input.Create("Test", Enum.InputPriority.Lowest)
	test:SetMapping(Enum.Input.Space)
	test.Events:Listen("InputChanged", function(input)
		if input.Direction.Z < 0 then
			print(unpack(Thread.DefaultSkybox.HarmonicsBuffer:getData(1)))
		end
	end)

	cameraMovement = Input.Create("CameraMovement", Enum.InputPriority.Lowest)
	cameraMovement:SetMapping(Enum.Input.W, Vector3.Forward)
	cameraMovement:SetMapping(Enum.Input.A, Vector3.Left)
	cameraMovement:SetMapping(Enum.Input.S, Vector3.Backward)
	cameraMovement:SetMapping(Enum.Input.D, Vector3.Right)
	cameraMovement:SetMapping(Enum.Input.E, Vector3.Up)
	cameraMovement:SetMapping(Enum.Input.Q, Vector3.Down)

	cameraRotate = Input.Create("CameraRotate", Enum.InputPriority.Lowest)
	cameraRotate:SetMapping(Enum.Input.RightMouseButton, Vector3.Forward)
	cameraRotate:SetMapping(Enum.Input.MouseMovement)

	cameraAngles = Vector3.Zero

	cube.Parent = Thread.World
	light.Parent = Thread.World

	fps.Parent = Thread.Interface
end

function Thread.Update(deltaTime)
	local camera = Thread.World.Camera

	if cameraMovement.Direction ~= Vector3.Zero then
		camera.Position = camera.Position + cameraMovement.Direction:Rotate(camera.Orientation):Normalise() * deltaTime
	end

	if cameraRotate.Direction.Z < 0 then
		lovr.system.setMouseMode("relative")

		cameraAngles = Vector3.Create(
			math.clamp(cameraAngles.X - cameraRotate.Direction.Y * 0.01, math.rad(-80), math.rad(80)),
			cameraAngles.Y - cameraRotate.Direction.X * 0.01,
			0
		)

		cameraRotate.Direction = Vector3.Forward
	else
		lovr.system.setMouseMode("normal")
	end
	
	camera.Orientation = Quaternion.CreateYXZRotation(cameraAngles)

	fps.Text = string.format("FPS: %d", lovr.timer:getFPS())
end