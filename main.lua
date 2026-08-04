require("init")

function Thread.Load()
	local fps = Label.Create()
	fps.Name = "FPS"
	fps.Size = ScaleOffset2.Create(0, 0, 150, 50)
	fps.HorizontalTextAlignment = Enum.HorizontalAlignment.Middle
	fps.VerticalTextAlignment = Enum.VerticalAlignment.Middle
	fps.CornerRadius = ScaleOffset4.Create(0, 0, 1, 0, 0, 0, 0, 0)
	fps.BackgroundColour = Vector4.Create(1, 1, 1, 0.8)

	root = Frame.Create()
	root.Name = "Root"
	root.Origin = ScaleOffset2.Create(0.5, 0.5, 0, 0)
	root.Size = ScaleOffset2.Create(0.8, 0.8, 0, 0)
	root.Position = ScaleOffset2.Create(0.5, 0.5, 0, 0)
	root.CornerRadius = ScaleOffset4.Create(0.1, 0.1, 0.1, 0.1, 0, 0, 0, 0)
	root.ChildOverflow = false

	local subframe1 = Frame.Create()
	subframe1.Name = "Subframe1"
	subframe1.Size = ScaleOffset2.Create(0.8, 0.5, 0, 0)
	subframe1.BackgroundColour = Vector4.Green
	subframe1.ChildOverflow = false

	local label1 = Label.Create()
	label1.Name = "Label1"
	label1.Size = ScaleOffset2.Create(1.5, 0.5, 0, 0)
	label1.Text = "Hello, everyone! This is the LONGEST TEXT EVER! I was inspired by the various other \"longest texts ever\" on the internet, and I wanted to make my own."
	label1.BackgroundColour = Vector4.Red

	local subframe2 = Frame.Create()
	subframe2.Name = "Subframe2"
	subframe2.Size = ScaleOffset2.Create(0.3, 0.3, 0, 0)
	subframe2.Position = ScaleOffset2.Create(0, 0.6, 0, 0)
	subframe2.BackgroundColour = Vector4.Black
	subframe2.ChildOverflow = true

	local label2 = Label.Create()
	label2.Name = "Label2"
	label2.Size = ScaleOffset2.Create(1.5, 0.5, 0, 0)
	label2.Text = "Hello, everyone! I am Josh and this is some really really really long text that I have typed out for you and everybody else!"
	label2.BackgroundColour = Vector4.Blue

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
	root.Parent = Thread.Interface
	subframe1.Parent = root
	label1.Parent = subframe1
	subframe2.Parent = root
	label2.Parent = subframe2

	floor.Parent = Thread.World
	cube.Parent = Thread.World
end

function Thread.Update(deltaTime)
	root.Angle = (root.Angle + 0.5 * deltaTime) % (2 * math.pi)
	print(root.AbsolutePosition)

	local camera = Thread.World.Camera

	if cameraMovement.Direction ~= Vector3.Zero then
		camera.Position = camera.Position + cameraMovement.Direction:Rotate(camera.Orientation):Normalise() * deltaTime
	end

	if cameraRotate.Direction.Z < 0 then
		lovr.system.setMouseMode("relative")

		cameraAngles = Vector3.Create(math.clamp(
			cameraAngles.X - cameraRotate.Direction.Y * 0.01, math.rad(-80), math.rad(80)),
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