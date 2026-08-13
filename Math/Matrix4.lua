local Matrix4 = {}

function Matrix4.Create(components)
	local self = Class.CreateInstance(nil, Matrix4)

	self._Position = nil
	self._Orientation = nil
	self._Scale = nil

	local componentsType = Class.GetType(components)
	if componentsType == "table" then
		self.Components = components
	elseif componentsType == "Matrix4" then
		self.Components = {unpack(components.Components)}
	elseif componentsType == "cdata" then
		self.Components = table.new(16, 0)

		self.Components[1] = components[0]
		self.Components[2] = components[1]
		self.Components[3] = components[2]
		self.Components[4] = components[3]

		self.Components[5] = components[4]
		self.Components[6] = components[5]
		self.Components[7] = components[6]
		self.Components[8] = components[7]

		self.Components[9] = components[8]
		self.Components[10] = components[9]
		self.Components[11] = components[10]
		self.Components[12] = components[11]

		self.Components[13] = components[12]
		self.Components[14] = components[13]
		self.Components[15] = components[14]
		self.Components[16] = components[15]
	else
		self.Components = {
			0, 0, 0, 0,
			0, 0, 0, 0,
			0, 0, 0, 0,
			0, 0, 0, 0
		}
	end

	return self
end

function Matrix4.CreateIdentity()
	return Matrix4.Create({
		1, 0, 0, 0,
		0, 1, 0, 0,
		0, 0, 1, 0,
		0, 0, 0, 1
	})
end

function Matrix4.CreateTransform(position, orientation, scale, origin)
	position = position or Vector3.Zero
	scale = scale or Vector3.One
	origin = origin or Vector3.Zero

	if not orientation then
		orientation = Quaternion.One
	elseif Class.IsA(orientation, "Vector3") then
		orientation = Quaternion.CreateYXZRotation(orientation)
	end
	
	local result = Matrix4.Create({
		scale.X, 0, 0, 0,
		0, scale.Y, 0, 0,
		0, 0, scale.Z, 0,
		-origin.X, -origin.Y, -origin.Z, 1
	})

	if orientation ~= Quaternion.One then
		result = orientation:ConvertToMatrix() * result
	end

	if position ~= Vector3.Zero then
		result = Matrix4.Create({
			1, 0, 0, 0,
			0, 1, 0, 0,
			0, 0, 1, 0,
			position.X, position.Y, position.Z, 1
		}) * result
	end

	return result
end

function Matrix4.CreateInterfaceProjection(width, height)
	return Matrix4.Create({
		2 / width, 0, 0, 0,
		0, 2 / height, 0, 0,
		0, 0, 0, 0,
		-1, -1, 0, 1
	})
end

function Matrix4.CreatePerspectiveProjection(aspectRatio, fov, near, far)
	local inverseTanOfHalfFOV = 1 / math.tan(fov * 0.5)

	return Matrix4.Create({
		inverseTanOfHalfFOV / aspectRatio, 0, 0, 0,
		0, -inverseTanOfHalfFOV, 0, 0,
		0, 0, far / (near - far), -1,
		0, 0, (far*near) / (near - far), 0
	})
end

function Matrix4:GetPosition()
	if not self._Position then
		local components = self.Components

		self._Position = Vector3.Create(components[13], components[14], components[15])
	end

	return self._Position
end

function Matrix4:GetScale()
	if not self._Scale then
		local components = self.Components

		self._Scale = Vector3.Create(
			math.sqrt(components[1]^2 + components[2]^2 + components[3]^2),
			math.sqrt(components[5]^2 + components[6]^2 + components[7]^2),
			math.sqrt(components[9]^2 + components[10]^2 + components[11]^2)
		)
	end

	return self._Scale
end

function Matrix4:GetOrientation()
	if not self._Orientation then
		local components = self.Components
		local sx, sy, sz = self.Scale:Unpack()

		local r11, r21, r31 = components[1]/sx, components[2]/sx, components[3]/sx
		local r12, r22, r32 = components[5]/sy, components[6]/sy, components[7]/sy
		local r13, r23, r33 = components[9]/sz, components[10]/sz, components[11]/sz

		local trace = r11 + r22 + r33
		local w, x, y, z

		if trace > 0.0 then
			local s = math.sqrt(1.0 + trace) * 2.0

			w = 0.25 * s
			x = (r32 - r23) / s
			y = (r13 - r31) / s
			z = (r21 - r12) / s
		elseif r11 > r22 and r11 > r33 then
			local s = math.sqrt(1.0 + r11 - r22 - r33) * 2.0

			w = (r32 - r23) / s
			x = 0.25 * s
			y = (r21 + r12) / s
			z = (r13 + r31) / s
		elseif r22 > r33 then
			local s = math.sqrt(1.0 + r22 - r11 - r33) * 2.0

			w = (r13 - r31) / s
			x = (r21 + r12) / s
			y = 0.25 * s
			z = (r32 + r23) / s
		else
			local s = math.sqrt(1.0 + r33 - r11 - r22) * 2.0

			w = (r21 - r12) / s
			x = (r13 + r31) / s
			y = (r32 + r23) / s
			z = 0.25 * s
		end

		self._Orientation = Quaternion.Create(w, x, y, z)
	end

	return self._Orientation
end

function Matrix4:Transpose()
	local components = self.Components

	return Matrix4.Create({
		components[1], components[5], components[9], components[13],
		components[2], components[6], components[10], components[14],
		components[3], components[7], components[11], components[15],
		components[4], components[8], components[12], components[16]
	})
end

function Matrix4:Inverse()
	local m = self.Components

    local m11, m12, m13, m14 = m[1],  m[2],  m[3],  m[4]
    local m21, m22, m23, m24 = m[5],  m[6],  m[7],  m[8]
    local m31, m32, m33, m34 = m[9],  m[10], m[11], m[12]
    local m41, m42, m43, m44 = m[13], m[14], m[15], m[16]

    local A2323 = m33 * m44 - m34 * m43
    local A1323 = m32 * m44 - m34 * m42
    local A1223 = m32 * m43 - m33 * m42
    local A0323 = m31 * m44 - m34 * m41
    local A0223 = m31 * m43 - m33 * m41
    local A0123 = m31 * m42 - m32 * m41
    local A2313 = m23 * m44 - m24 * m43
    local A1313 = m22 * m44 - m24 * m42
    local A1213 = m22 * m43 - m23 * m42
    local A2312 = m23 * m34 - m24 * m33
    local A1312 = m22 * m34 - m24 * m32
    local A1212 = m22 * m33 - m23 * m32
    local A0313 = m21 * m44 - m24 * m41
    local A0213 = m21 * m43 - m23 * m41
    local A0312 = m21 * m34 - m24 * m31
    local A0212 = m21 * m33 - m23 * m31
    local A0113 = m21 * m42 - m22 * m41
    local A0112 = m21 * m32 - m22 * m31

    local det = m11 * ( m22 * A2323 - m23 * A1323 + m24 * A1223 )
              - m12 * ( m21 * A2323 - m23 * A0323 + m24 * A0223 )
              + m13 * ( m21 * A1323 - m22 * A0323 + m24 * A0123 )
              - m14 * ( m21 * A1223 - m22 * A0223 + m23 * A0123 )

    local invDet = 1 / det

    return Matrix4.Create({
        invDet * ( m22 * A2323 - m23 * A1323 + m24 * A1223 ),
        invDet * -( m12 * A2323 - m13 * A1323 + m14 * A1223 ),
        invDet * ( m12 * A2313 - m13 * A1313 + m14 * A1213 ),
        invDet * -( m12 * A2312 - m13 * A1312 + m14 * A1212 ),

        invDet * -( m21 * A2323 - m23 * A0323 + m24 * A0223 ),
        invDet * ( m11 * A2323 - m13 * A0323 + m14 * A0223 ),
        invDet * -( m11 * A2313 - m13 * A0313 + m14 * A0213 ),
        invDet * ( m11 * A2312 - m13 * A0312 + m14 * A0212 ),

        invDet * ( m21 * A1323 - m22 * A0323 + m24 * A0123 ),
        invDet * -( m11 * A1323 - m12 * A0323 + m14 * A0123 ),
        invDet * ( m11 * A1313 - m12 * A0313 + m14 * A0113 ),
        invDet * -( m11 * A1312 - m12 * A0312 + m14 * A0112 ),

        invDet * -( m21 * A1223 - m22 * A0223 + m23 * A0123 ),
        invDet * ( m11 * A1223 - m12 * A0223 + m13 * A0123 ),
        invDet * -( m11 * A1213 - m12 * A0213 + m13 * A0113 ),
        invDet * ( m11 * A1212 - m12 * A0212 + m13 * A0112 )
    })
end

function Matrix4:Unpack()
	return unpack(self.Components)
end

function Matrix4.__mul(left, right)
	left = left.Components

	local rightType = Class.GetType(right)
	if rightType == "Matrix4" then
		right = right.Components

		return Matrix4.Create({
			-- Column 1
            left[1]*right[1]  + left[5]*right[2]  + left[9]*right[3]  + left[13]*right[4],
            left[2]*right[1]  + left[6]*right[2]  + left[10]*right[3] + left[14]*right[4],
            left[3]*right[1]  + left[7]*right[2]  + left[11]*right[3] + left[15]*right[4],
            left[4]*right[1]  + left[8]*right[2]  + left[12]*right[3] + left[16]*right[4],

            -- Column 2
            left[1]*right[5]  + left[5]*right[6]  + left[9]*right[7]  + left[13]*right[8],
            left[2]*right[5]  + left[6]*right[6]  + left[10]*right[7] + left[14]*right[8],
            left[3]*right[5]  + left[7]*right[6]  + left[11]*right[7] + left[15]*right[8],
            left[4]*right[5]  + left[8]*right[6]  + left[12]*right[7] + left[16]*right[8],

            -- Column 3
            left[1]*right[9]  + left[5]*right[10] + left[9]*right[11] + left[13]*right[12],
            left[2]*right[9]  + left[6]*right[10] + left[10]*right[11] + left[14]*right[12],
            left[3]*right[9]  + left[7]*right[10] + left[11]*right[11] + left[15]*right[12],
            left[4]*right[9]  + left[8]*right[10] + left[12]*right[11] + left[16]*right[12],

            -- Column 4
            left[1]*right[13] + left[5]*right[14] + left[9]*right[15] + left[13]*right[16],
            left[2]*right[13] + left[6]*right[14] + left[10]*right[15] + left[14]*right[16],
            left[3]*right[13] + left[7]*right[14] + left[11]*right[15] + left[15]*right[16],
            left[4]*right[13] + left[8]*right[14] + left[12]*right[15] + left[16]*right[16],
		})
	elseif rightType == "Vector3" then
		local x, y, z = right:Unpack()

		return Vector3.Create(
			left[1]*x + left[5]*y + left[9]*z + left[13],
        	left[2]*x + left[6]*y + left[10]*z + left[14],
        	left[3]*x + left[7]*y + left[11]*z + left[15]
		)
	elseif rightType == "Vector2" then
		local x, y = right:Unpack()

		return Vector2.Create(
			left[1]*x + left[5]*y + left[13],
        	left[2]*x + left[6]*y + left[14]
		)
	elseif rightType == "number" then
		return Matrix4.Create({
			left[1]*right, left[2]*right, left[3]*right, left[4]*right,
			left[5]*right, left[6]*right, left[7]*right, left[8]*right,
			left[9]*right, left[10]*right, left[11]*right, left[12]*right,
			left[13]*right, left[14]*right, left[15]*right, left[16]*right,
		})
	end
end

function Matrix4.__eq(left, right)
	left = left.Components
	right = right.Components

	return
		left[1] == right[1] and left[2] == right[2] and left[3] == right[3] and left[4] == right[4] and
		left[5] == right[5] and left[6] == right[6] and left[7] == right[7] and left[8] == right[8] and
		left[9] == right[9] and left[10] == right[10] and left[11] == right[11] and left[12] == right[12] and
		left[13] == right[13] and left[14] == right[14] and left[15] == right[15] and left[16] == right[16]
end

function Matrix4.__tostring(matrix)
	matrix = matrix.Components

	return string.format(
		"\n|%-.3f, %-.3f, %-.3f, %-.3f|\n|%-.3f, %-.3f, %-.3f, %-.3f|\n|%-.3f, %-.3f, %-.3f, %-.3f|\n|%-.3f, %-.3f, %-.3f, %-.3f|\n",
		matrix[1], matrix[5], matrix[9], matrix[13],
		matrix[2], matrix[6], matrix[10], matrix[14],
		matrix[3], matrix[7], matrix[11], matrix[15],
		matrix[4], matrix[8], matrix[12], matrix[16]
	)
end

Class.CreateClass(Matrix4, "Matrix4")

Matrix4.Zero = Matrix4.Create()
Matrix4.Identity = Matrix4.CreateIdentity()

return Matrix4