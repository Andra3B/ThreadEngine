local Vector2 = {}

function Vector2.Create(x, y)
	local self = Class.CreateInstance(nil, Vector2)
	
	self.X = x
	self.Y = y
	
	return self
end

function Vector2:Rotate(angle)
	local sine, cos = math.sin(angle), math.cos(angle)

	return Vector2.Create(
		self.X*cos - self.Y*sine,
		self.X*sine + self.Y*cos
	)
end

function Vector2:Lerp(to, alpha)
	return Vector2.Create(
		self.X + alpha * (to.X - self.X),
		self.Y + alpha * (to.Y - self.Y)
	)
end

function Vector2:Dot(other)
	return
		self.X * other.X +
		self.Y * other.Y
end

function Vector2:GetSquaredMagnitude()
	return self.X^2 + self.Y^2
end

function Vector2:GetMagnitude()
	return math.sqrt(self.X^2 + self.Y^2)
end

function Vector2:Normalise()
	local inverseMagnitude = 1 / math.sqrt(self.X^2 + self.Y^2)

	return Vector2.Create(
		self.X * inverseMagnitude,
		self.Y * inverseMagnitude
	)
end

function Vector2:Unpack()
	return self.X, self.Y
end

function Vector2.__add(left, right)
	local leftX, leftY = left:Unpack()
	local rightX, rightY

	if type(right) == "number" then
		rightX = right
		rightY = right
	else
		rightX, rightY = right:Unpack()
	end

	return Vector2.Create(
		leftX + rightX,
		leftY + rightY
	)
end

function Vector2.__sub(left, right)
	local leftX, leftY = left:Unpack()
	local rightX, rightY

	if type(right) == "number" then
		rightX = right
		rightY = right
	else
		rightX, rightY = right:Unpack()
	end

	return Vector2.Create(
		leftX - rightX,
		leftY - rightY
	)
end

function Vector2.__mul(left, right)
	local leftX, leftY = left:Unpack()
	local rightX, rightY

	if type(right) == "number" then
		rightX = right
		rightY = right
	else
		rightX, rightY = right:Unpack()
	end

	return Vector2.Create(
		leftX * rightX,
		leftY * rightY
	)
end

function Vector2.__div(left, right)
	local leftX, leftY = left:Unpack()
	local rightX, rightY

	if type(right) == "number" then
		rightX = right
		rightY = right
	else
		rightX, rightY = right:Unpack()
	end

	return Vector2.Create(
		leftX / rightX,
		leftY / rightY
	)
end

function Vector2.__unm(vector)
	local x, y = vector:Unpack()

	return Vector2.Create(-x, -y)
end

function Vector2.__eq(left, right)
	local leftX, leftY = left:Unpack()
	local rightX, rightY = right:Unpack()

	return leftX == rightX and leftY == rightY
end

function Vector2.__tostring(vector)
	return string.format("(%.3f, %.3f)", vector:Unpack())
end

Class.CreateClass(Vector2, "Vector2")

Vector2.Zero = Vector2.Create(0, 0)
Vector2.One = Vector2.Create(1, 1)

Vector2.Up = Vector2.Create(0, 1)
Vector2.Down = Vector2.Create(0, -1)
Vector2.Left = Vector2.Create(-1, 0)
Vector2.Right = Vector2.Create(1, 0)

return Vector2