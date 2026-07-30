require("init")

function Thread.Load()
	local fps = Label.Create()
	fps.Name = "FPS"
	fps.Size = ScaleOffset2.Create(0, 0, 150, 50)
	fps.HorizontalTextAlignment = Enum.HorizontalAlignment.Middle
	fps.VerticalTextAlignment = Enum.VerticalAlignment.Middle
	fps.CornerRadius = ScaleOffset4.Create(0, 0, 1, 0, 0, 0, 0, 0)
	fps.BackgroundColour = Vector4.Create(1, 1, 1, 0.8)
	
	local button = Button.Create()
	button.Origin = ScaleOffset2.Create(0.5, 0.5, 0, 0)
	button.Size = ScaleOffset2.Create(0.8, 0.2, 0, 0)
	button.Position = ScaleOffset2.Create(0.5, 0.5, 0, 0)
	button.Text = "Print Hi"
	button.HorizontalTextAlignment = Enum.HorizontalAlignment.Middle
	button.VerticalTextAlignment = Enum.VerticalAlignment.Middle
	button.Events:Listen("PressedChanged", function(source, pressed)
		if pressed then
			print("Hello, world!")
		end
	end)

	local floor = Body.Create()
	floor.Mesh = Thread.Meshes.Cube
	floor.Material = Thread.Materials.Green
	floor:AddColliderShape(lovr.physics.newBoxShape(20, 1, 20))
	floor.Kinematic = true
	floor.Scale = Vector3.Create(20, 1, 20)
	floor.Position = Vector3.Create(0, -0.5, 0)

	local cube = Body.Create()
	cube.Mesh = Thread.Meshes.Cube
	cube:AddColliderShape(lovr.physics.newBoxShape(1, 1, 1))
	cube.Position = Vector3.Create(0, 2, 0)

	cameraMovement = Input.Create("CameraMovement", Enum.InputPriority.Lowest)
	cameraMovement:SetMapping(Enum.Input.W, Vector3.Forward)
	cameraMovement:SetMapping(Enum.Input.A, Vector3.Left)
	cameraMovement:SetMapping(Enum.Input.S, Vector3.Backward)
	cameraMovement:SetMapping(Enum.Input.D, Vector3.Right)
	cameraMovement:SetMapping(Enum.Input.E, Vector3.Up)
	cameraMovement:SetMapping(Enum.Input.Q, Vector3.Down)

	cameraRotate = Input.Create("CameraRotate", Enum.InputPriority.Lowest)
	cameraRotate:SetMapping(Enum.Input.RightMouseButton)
	cameraRotate:SetMapping(Enum.Input.MouseMovement)

	cameraAngles = Vector3.Zero
	
	Thread.World.Camera.Position = Vector3.Create(0, 1, 2)

	fps.Parent = Thread.Interface
	button.Parent = Thread.Interface

	floor.Parent = Thread.World
	cube.Parent = Thread.World
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
	
	Thread.Interface:GetDescendantWithName("FPS").Text = string.format("FPS: %d", lovr.timer:getFPS())
end

function Thread.PhysicsUpdate(deltaTime)
	
end