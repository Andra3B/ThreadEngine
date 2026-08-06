local Vector3 = {}

function Vector3.Create(x, y, z)
	local self = Class.CreateInstance(nil, Vector3)
	
	self.X = x
	self.Y = y
	self.Z = z
	
	return self
end

function Vector3:Rotate(quaternion)
	local w, v = quaternion.Real, quaternion.Vector
	local vpCross = v:Cross(self)

	return self + (vpCross * w + v:Cross(vpCross)) * 2
end

function Vector3:Lerp(other, alpha)
	return Vector3.Create(
		self.X + alpha * (other.X - self.X),
		self.Y + alpha * (other.Y - self.Y),
		self.Z + alpha * (other.Z - self.Z)
	)
end

function Vector3:Dot(other)
	return
		self.X * other.X +
		self.Y * other.Y +
		self.Z * other.Z
end

function Vector3:Cross(other)
	local selfX, selfY, selfZ = self:Unpack()
	local x, y, z = other:Unpack()

	return Vector3.Create(
		selfY*z - selfZ*y,
		selfZ*x - selfX*z,
		selfX*y - selfY*x
	)
end

function Vector3:GetSquaredMagnitude()
	return self.X^2 + self.Y^2 + self.Z^2
end

function Vector3:GetMagnitude()
	return math.sqrt(self.X^2 + self.Y^2 + self.Z^2)
end

function Vector3:Normalise()
	local inverseMagnitude = 1 / math.sqrt(self.X^2 + self.Y^2 + self.Z^2)

	return Vector3.Create(
		self.X * inverseMagnitude,
		self.Y * inverseMagnitude,
		self.Z * inverseMagnitude
	)
end

function Vector3:Unpack()
	return self.X, self.Y, self.Z
end

function Vector3.__add(left, right)
	local leftX, leftY, leftZ = left:Unpack()
	local rightX, rightY, rightZ

	if type(right) == "number" then
		rightX = right
		rightY = right
		rightZ = right
	else
		rightX, rightY, rightZ = right:Unpack()
	end

	return Vector3.Create(
		leftX + rightX,
		leftY + rightY,
		leftZ + rightZ
	)
end

function Vector3.__sub(left, right)
	local leftX, leftY, leftZ = left:Unpack()
	local rightX, rightY, rightZ

	if type(right) == "number" then
		rightX = right
		rightY = right
		rightZ = right
	else
		rightX, rightY, rightZ = right:Unpack()
	end

	return Vector3.Create(
		leftX - rightX,
		leftY - rightY,
		leftZ - rightZ
	)
end

function Vector3.__mul(left, right)
	local leftX, leftY, leftZ = left:Unpack()
	local rightX, rightY, rightZ

	if type(right) == "number" then
		rightX = right
		rightY = right
		rightZ = right
	else
		rightX, rightY, rightZ = right:Unpack()
	end

	return Vector3.Create(
		leftX * rightX,
		leftY * rightY,
		leftZ * rightZ
	)
end

function Vector3.__div(left, right)
	local leftX, leftY, leftZ = left:Unpack()
	local rightX, rightY, rightZ

	if type(right) == "number" then
		rightX = right
		rightY = right
		rightZ = right
	else
		rightX, rightY, rightZ = right:Unpack()
	end

	return Vector3.Create(
		leftX / rightX,
		leftY / rightY,
		leftZ / rightZ
	)
end

function Vector3.__unm(vector)
	local x, y, z = vector:Unpack()

	return Vector3.Create(-x, -y, -z)
end

function Vector3.__eq(left, right)
	local leftX, leftY, leftZ = left:Unpack()
	local rightX, rightY, rightZ = right:Unpack()

	return leftX == rightX and leftY == rightY and leftZ == rightZ
end

function Vector3.__tostring(vector)
	return string.format("(%.3f, %.3f, %.3f)", vector:Unpack())
end

Class.CreateClass(Vector3, "Vector3")

Vector3.Zero = Vector3.Create(0, 0, 0)
Vector3.One = Vector3.Create(1, 1, 1)

Vector3.Up = Vector3.Create(0, 1, 0)
Vector3.Down = Vector3.Create(0, -1, 0)
Vector3.Left = Vector3.Create(-1, 0, 0)
Vector3.Right = Vector3.Create(1, 0, 0)
Vector3.Forward = Vector3.Create(0, 0, -1)
Vector3.Backward = Vector3.Create(0, 0, 1)

return Vector3