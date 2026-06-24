require("init")

function Thread.Load()
	cube = Body.Create()	
	fps = Label.Create()

	fps.Name = "FPS Label"

	fps.Size = ScaleOffset2.Create(0, 0, 150, 50)
	fps.HorizontalTextAlignment = Enum.HorizontalAlignment.Middle
	fps.VerticalTextAlignment = Enum.VerticalAlignment.Middle
	fps.CornerRadius = ScaleOffset4.Create(0, 0, 1, 0, 0, 0, 0, 0)

	cube.Position = Vector3.Create(0, 0, -3)

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

	cube.Parent = Thread.World
	fps.Parent = Thread.Interface
end

function Thread.Update(deltaTime)
	local camera = Thread.World.Camera

	if cameraMovement.Direction ~= Vector3.Zero then
		camera.Position = camera.Position + cameraMovement.Direction:Rotate(camera.Orientation):Normalise() * deltaTime
		print(camera.Position)
	end

	fps.Text = string.format("FPS: %d", lovr.timer:getFPS())
end