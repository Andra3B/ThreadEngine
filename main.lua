require("init")

function Thread.Load()
	label = Label.Create()

	label.Name = "Label 1"

	label.Size = ScaleOffset2.Create(0.3, 0.3, 0, 0)
	label.Position = ScaleOffset2.Create(0.5, 0.5, 0, 0)
	label.Origin = ScaleOffset2.Create(0.5, 0.5, 0, 0)
	label.HorizontalTextAlignment = Enum.HorizontalAlignment.Middle
	label.VerticalTextAlignment = Enum.VerticalAlignment.Middle
	
	label.CornerRadius = ScaleOffset4.Create(1, 0, 1, 0, 0, 0, 0, 0)

	label.Text = "Hello, world!"

	label.Parent = Thread.Interface
end

function Thread.Update(deltaTime)
	label.Angle = (label.Angle + 0.005) % (2 * math.pi)
end

function Thread.Quit(exitCode)
	label:Destroy()
end