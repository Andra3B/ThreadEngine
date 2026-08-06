local Quaternion = {}

function Quaternion.Create(w, x, y, z)
	local self = Class.CreateInstance(nil, Quaternion)
	
	self.W = w

	if type(x) == "number" then
		self.X = x
		self.Y = y
		self.Z = z
	else
		self.X = x.X
		self.Y = x.Y
		self.Z = x.Z
	end

	return self
end

function Quaternion.CreateLookAlong(forward, up)
	up = up or Vector3.Up

	local right = Vector3.Cross(up, forward)

	if right.SquaredMagnitude < 1e-9 then
		if math.abs(forward.Y) < 0.999 then
			up = Vector3.Up
		else
			up = Vector3.Forward
		end

		right = Vector3.Cross(up, forward)
	end

	right = right:Normalise()
	up = Vector3.Cross(forward, right)

	local m00, m01, m02 = right.X, up.X, forward.X
	local m10, m11, m12 = right.Y, up.Y, forward.Y
	local m20, m21, m22 = right.Z, up.Z, forward.Z

	local w, x, y, z
	local trace = m00 + m01 + m02

	if trace > 0 then
		local s = math.sqrt(trace + 1.0) * 2

		w = 0.25 * s
		x = (m21 - m12) / s
		y = (m02 - m20) / s
    	z = (m10 - m01) / s
	elseif m00 > m11 and m00 > m22 then
    	local s = math.sqrt(1.0 + m00 - m11 - m22) * 2

    	w = (m21 - m12) / s
    	x = 0.25 * s
    	y = (m01 + m10) / s
    	z = (m02 + m20) / s
    elseif m11 > m22 then
		local s = math.sqrt(1.0 + m11 - m00 - m22) * 2

    	w = (m02 - m20) / s
    	x = (m01 + m10) / s
    	y = 0.25 * s
    	z = (m12 + m21) / s
    else
    	local s = math.sqrt(1.0 + m22 - m00 - m11) * 2
		
    	w = (m10 - m01) / s
    	x = (m02 + m20) / s
    	y = (m12 + m21) / s
    	z = 0.25 * s
    end

	return Quaternion.Create(w, x, y, z)
end

function Quaternion.CreateAxisRotation(angle, axisX, axisY, axisZ)
	local axis = nil

	if type(axisX) == "number" then
		axis = Vector3.Create(axisX, axisY, axisZ)
	else
		axis = axisX
	end

	local axisMagnitude = axis.Magnitude

	if axisMagnitude == 0 then
		return Quaternion.One
	else
		local halfAngle = angle * 0.5
		local factor = math.sin(halfAngle) / axisMagnitude

		return Quaternion.Create(
			math.cos(halfAngle),
			axis.X * factor,
			axis.Y * factor,
			axis.Z * factor
		)
	end
end

function Quaternion:GetAngleAxis(unpacked)
	local halfAngle = math.acos(self.W)
	local inverseFactor = halfAngle == 0 and 0 or (1 / math.sin(halfAngle))

	local axisX = self.X * inverseFactor
	local axisY = self.Y * inverseFactor
	local axisZ = self.Z * inverseFactor

	if unpacked then
		return halfAngle * 2, axisX, axisY, axisZ
	else
		return halfAngle * 2, Vector3.Create(axisX, axisY, axisZ)
	end
end

function Quaternion.CreateYXZRotation(angles)
	return
		Quaternion.CreateAxisRotation(angles.Y, Vector3.Up) *
		Quaternion.CreateAxisRotation(angles.X, Vector3.Right) *
		Quaternion.CreateAxisRotation(angles.Z, Vector3.Forward)
end

function Quaternion:Dot(other)
	return
		self.W * other.W +
		self.X * other.X +
		self.Y * other.Y +
		self.Z * other.Z
end

function Quaternion:GetSquaredMagnitude()
	return self.W^2 + self.X^2 + self.Y^2 + self.Z^2
end

function Quaternion:GetMagnitude()
	return math.sqrt(self.W^2 + self.X^2 + self.Y^2 + self.Z^2)
end

function Quaternion:Normalise()
	local inverseMagnitude = 1 / math.sqrt(self.W^2 + self.X^2 + self.Y^2 + self.Z^2)

	return Quaternion.Create(
		self.W * inverseMagnitude,
		self.X * inverseMagnitude,
		self.Y * inverseMagnitude,
		self.Z * inverseMagnitude
	)
end

function Quaternion:Conjugate()
	return Quaternion.Create(self.W, -self.X, -self.Y, -self.Z)
end

function Quaternion:Inverse()
	local inverseMagnitude = 1 / math.sqrt(self.W^2 + self.X^2 + self.Y^2 + self.Z^2)

	return Quaternion.Create(
		self.W * inverseMagnitude,
		self.X * -inverseMagnitude,
		self.Y * -inverseMagnitude,
		self.Z * -inverseMagnitude
	)
end

function Quaternion:ConvertToMatrix()
	local w, x, y, z = self:Unpack()

	return Matrix4.Create({
		1 - 2*(y*y + z*z), 2*(x*y + w*z), 2*(x*z - w*y), 0,
		2*(x*y - w*z), 1 - 2*(x*x + z*z), 2*(y*z + w*x), 0,
		2*(x*z + w*y), 2*(y*z - w*x), 1 - 2*(x*x + y*y), 0,
		0, 0, 0, 1
	})
end

function Quaternion:Slerp(to, alpha)
	local w1, x1, y1, z1 = self:Unpack()
	local w2, x2, y2, z2 = to:Unpack()

	local dot = w1*w2 + x1*x2 + y1*y2 + z1*z2

	if dot < 0 then
		w2 = -w2
		x2 = -x2
		y2 = -y2
		z2 = -z2

		dot = -dot
	end

	local rw, rx, ry, rz

	if dot > 0.9995 then
		local scale1 = 1 - alpha
		local scale2 = alpha

		rw = scale1*w1 + scale2*w2
		rx = scale1*x1 + scale2*x2
		ry = scale1*y1 + scale2*y2
		rz = scale1*z1 + scale2*z2

		local inverseMagnitude = 1 / math.sqrt(rw*rw + rx*rx + ry*ry + rz*rz)

		rw = rw*inverseMagnitude
		rx = rx*inverseMagnitude
		ry = ry*inverseMagnitude
		rz = rz*inverseMagnitude
	else
		local theta = math.acos(dot)
		local sinTheta = math.sin(theta)

		local scale1 = math.sin((1 - alpha) * theta) / sinTheta
		local scale2 = math.sin(alpha * theta) / sinTheta

		rw = scale1*w1 + scale2*w2
		rx = scale1*x1 + scale2*x2
		ry = scale1*y1 + scale2*y2
		rz = scale1*z1 + scale2*z2
	end

	return Quaternion.Create(rw, rx, ry, rz)
end

function Quaternion:GetReal()
	return self.W
end

function Quaternion:GetVector()
	return Vector3.Create(self.X, self.Y, self.Z)
end

function Quaternion:Unpack()
	return self.W, self.X, self.Y, self.Z
end

function Quaternion.__add(left, right)
	local leftW, leftX, leftY, leftZ = left:Unpack()
	local rightW, rightX, rightY, rightZ

	if type(right) == "number" then
		rightW = right
		rightX = right
		rightY = right
		rightZ = right
	else
		rightW, rightX, rightY, rightZ = right:Unpack()
	end

	return Quaternion.Create(
		leftW + rightW,
		leftX + rightX,
		leftY + rightY,
		leftZ + rightZ
	)
end

function Quaternion.__sub(left, right)
	local leftW, leftX, leftY, leftZ = left:Unpack()
	local rightW, rightX, rightY, rightZ

	if type(right) == "number" then
		rightW = right
		rightX = right
		rightY = right
		rightZ = right
	else
		rightW, rightX, rightY, rightZ = right:Unpack()
	end

	return Quaternion.Create(
		leftW - rightW,
		leftX - rightX,
		leftY - rightY,
		leftZ - rightZ
	)
end

function Quaternion.__mul(left, right)
	local leftW, leftX, leftY, leftZ = left:Unpack()

	if type(right) == "number" then
		return Quaternion.Create(
			leftW*right,
			leftX*right,
			leftY*right,
			leftZ*right
		)
	else
		local rightW, rightX, rightY, rightZ = right:Unpack()

		return Quaternion.Create(
			leftW*rightW - leftX*rightX - leftY*rightY - leftZ*rightZ,
			leftW*rightX + leftX*rightW + leftY*rightZ - leftZ*rightY,
			leftW*rightY - leftX*rightZ + leftY*rightW + leftZ*rightX,
			leftW*rightZ + leftX*rightY - leftY*rightX + leftZ*rightW
		)
	end

end

function Quaternion.__div(left, right)
	return left * (type(right) == "number" and (1 / right) or right:Inverse())
end

function Quaternion.__unm(quaternion)
	local w, x, y, z = quaternion:Unpack()

	return Quaternion.Create(-w, -x, -y, -z)
end

function Quaternion.__eq(left, right)
	local leftW, leftX, leftY, leftZ = left:Unpack()
	local rightW, rightX, rightY, rightZ = right:Unpack()

	return leftW == rightW and leftX == rightX and leftY == rightY and leftZ == rightZ
end

function Quaternion.__tostring(quaternion)
	return string.format("{%.3f, (%.3f, %.3f, %.3f)}", quaternion:Unpack())
end

Class.CreateClass(Quaternion, "Quaternion")

Quaternion.Zero = Quaternion.Create(0, 0, 0, 0)
Quaternion.One = Quaternion.Create(1, 0, 0, 0)

return Quaternion