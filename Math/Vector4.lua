local Vector4 = {}

function Vector4.Create(x, y, z, w)
	local self = Class.CreateInstance(nil, Vector4)
	
	self.X = x
	self.Y = y
	self.Z = z
	self.W = w
	
	return self
end

function Vector4:Lerp(other, alpha)
	return Vector4.Create(
		self.X + alpha * (other.X - self.X),
		self.Y + alpha * (other.Y - self.Y),
		self.Z + alpha * (other.Z - self.Z),
		self.W + alpha * (other.W - self.W)
	)
end

function Vector4:Dot(other)
	return
		self.X * other.X +
		self.Y * other.Y +
		self.Z * other.Z +
		self.W * other.W
end

function Vector4:GetSquaredMagnitude()
	return self.X^2 + self.Y^2 + self.Z^2 + self.W^2
end

function Vector4:GetMagnitude()
	return math.sqrt(self.X^2 + self.Y^2 + self.Z^2 + self.W^2)
end

function Vector4:Normalise()
	local inverseMagnitude = 1 / math.sqrt(self.X^2 + self.Y^2 + self.Z^2 + self.W^2)

	return Vector4.Create(
		self.X * inverseMagnitude,
		self.Y * inverseMagnitude,
		self.Z * inverseMagnitude,
		self.W * inverseMagnitude
	)
end

function Vector4:Unpack()
	return self.X, self.Y, self.Z, self.W
end

function Vector4.__add(left, right)
	local leftX, leftY, leftZ, leftW = left:Unpack()
	local rightX, rightY, rightZ, rightW

	if type(right) == "number" then
		rightX = right
		rightY = right
		rightZ = right
		rightW = right
	else
		rightX, rightY, rightZ, rightW = right:Unpack()
	end

	return Vector4.Create(
		leftX + rightX,
		leftY + rightY,
		leftZ + rightZ,
		leftW + rightW
	)
end

function Vector4.__sub(left, right)
	local leftX, leftY, leftZ, leftW = left:Unpack()
	local rightX, rightY, rightZ, rightW

	if type(right) == "number" then
		rightX = right
		rightY = right
		rightZ = right
		rightW = right
	else
		rightX, rightY, rightZ, rightW = right:Unpack()
	end

	return Vector4.Create(
		leftX - rightX,
		leftY - rightY,
		leftZ - rightZ,
		leftW - rightW
	)
end

function Vector4.__mul(left, right)
	local leftX, leftY, leftZ, leftW = left:Unpack()
	local rightX, rightY, rightZ, rightW

	if type(right) == "number" then
		rightX = right
		rightY = right
		rightZ = right
		rightW = right
	else
		rightX, rightY, rightZ, rightW = right:Unpack()
	end

	return Vector4.Create(
		leftX * rightX,
		leftY * rightY,
		leftZ * rightZ,
		leftW * rightW
	)
end

function Vector4.__div(left, right)
	local leftX, leftY, leftZ, leftW = left:Unpack()
	local rightX, rightY, rightZ, rightW

	if type(right) == "number" then
		rightX = right
		rightY = right
		rightZ = right
		rightW = right
	else
		rightX, rightY, rightZ, rightW = right:Unpack()
	end

	return Vector4.Create(
		leftX / rightX,
		leftY / rightY,
		leftZ / rightZ,
		leftW / rightW
	)
end

function Vector4.__unm(vector)
	local x, y, z, w = vector:Unpack()

	return Vector4.Create(-x, -y, -z, -w)
end

function Vector4.__eq(left, right)
	local leftX, leftY, leftZ, leftW = left:Unpack()
	local rightX, rightY, rightZ, rightW = right:Unpack()

	return leftX == rightX and leftY == rightY and leftZ == rightZ and leftW == rightW
end

function Vector4.__tostring(vector)
	return string.format("(%.3f, %.3f, %.3f, %.3f)", vector:Unpack())
end

Class.CreateClass(Vector4, "Vector4")

Vector4.Zero = Vector4.Create(0, 0, 0, 0)
Vector4.One = Vector4.Create(1, 1, 1, 1)

Vector4.Up = Vector4.Create(0, 1, 0, 0)
Vector4.Down = Vector4.Create(0, -1, 0, 0)
Vector4.Left = Vector4.Create(-1, 0, 0, 0)
Vector4.Right = Vector4.Create(1, 0, 0, 0)
Vector4.Forward = Vector4.Create(0, 0, -1, 0)
Vector4.Backward = Vector4.Create(0, 0, 1, 0)

Vector4.Black = Vector4.Create(0, 0, 0, 1)
Vector4.White = Vector4.Create(1, 1, 1, 1)
Vector4.Red = Vector4.Create(1, 0, 0, 1)
Vector4.Green = Vector4.Create(0, 1, 0, 1)
Vector4.Blue = Vector4.Create(0, 0, 1, 1)

return Vector4