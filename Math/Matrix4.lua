local Matrix4 = {}

function Matrix4.Create(components)
	local self = Class.CreateInstance(nil, Matrix4)

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

function Matrix4.CreateTransform(position, orientation, size, origin)
	position = position or Vector3.Zero
	size = size or Vector3.One
	origin = origin or Vector3.Zero

	if not orientation then
		orientation = Quaternion.One
	elseif Class.IsA(orientation, "Vector3") then
		orientation = Quaternion.CreateYXZRotation(orientation)
	end

	-- Combined origin offset and size matrix
	local result = Matrix4.Create({
		size.X, 0, 0, -origin.X,
		0, size.Y, 0, -origin.Y,
		0, 0, size.Z, -origin.Z,
		0, 0, 0, 1
	})

	if orientation ~= Quaternion.One then
		result = orientation:ConvertToRotationMatrix() * result
	end

	if position ~= Vector3.Zero then
		result = Matrix4.Create({
			1, 0, 0, position.X,
			0, 1, 0, position.Y,
			0, 0, 1, position.Z,
			0, 0, 0, 1
		}) * result
	end

	return result
end

function Matrix4.CreateInterfaceProjection(width, height)
	return Matrix4.Create({
		2 / width, 0, 0, -1,
		0, -2 / height, 0, 1,
		0, 0, 0, 0,
		0, 0, 0, 1
	})
end

function Matrix4.CreatePerspectiveProjection(aspectRatio, fov, near, far)
	local inverseTanOfHalfFOV = 1 / math.tan(fov * 0.5)

	return Matrix4.Create({
		inverseTanOfHalfFOV / aspectRatio, 0, 0, 0,
		0, inverseTanOfHalfFOV, 0, 0,
		0, 0, (far + near) / (far - near), (-2 * far * near) / (far - near),
		0, 0, 1, 0
	})
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
	local a00,a01,a02,a03,a10,a11,a12,a13,a20,a21,a22,a23,a30,a31,a32,a33 = unpack(self.Components)

	local b00 = a00*a11 - a01*a10
    local b01 = a00*a12 - a02*a10
    local b02 = a00*a13 - a03*a10
    local b03 = a01*a12 - a02*a11
    local b04 = a01*a13 - a03*a11
    local b05 = a02*a13 - a03*a12
    local b06 = a20*a31 - a21*a30
    local b07 = a20*a32 - a22*a30
    local b08 = a20*a33 - a23*a30
    local b09 = a21*a32 - a22*a31
    local b10 = a21*a33 - a23*a31
    local b11 = a22*a33 - a23*a32

	local invDet = 1 / (b00*b11 - b01*b10 + b02*b09 + b03*b08 - b04*b07 + b05*b06)

	return Matrix4.Create({
		( a11*b11 - a12*b10 + a13*b09) * invDet,
		(-a01*b11 + a02*b10 - a03*b09) * invDet,
    	( a31*b05 - a32*b04 + a33*b03) * invDet,
    	(-a21*b05 + a22*b04 - a23*b03) * invDet,
    	(-a10*b11 + a12*b08 - a13*b07) * invDet,
    	( a00*b11 - a02*b08 + a03*b07) * invDet,
    	(-a30*b05 + a32*b02 - a33*b01) * invDet,
    	( a20*b05 - a22*b02 + a23*b01) * invDet,
    	( a10*b10 - a11*b08 + a13*b06) * invDet,
    	(-a00*b10 + a01*b08 - a03*b06) * invDet,
    	( a30*b04 - a31*b02 + a33*b00) * invDet,
    	(-a20*b04 + a21*b02 - a23*b00) * invDet,
    	(-a10*b09 + a11*b07 - a12*b06) * invDet,
    	( a00*b09 - a01*b07 + a02*b06) * invDet,
    	(-a30*b03 + a31*b01 - a32*b00) * invDet,
    	( a20*b03 - a21*b01 + a22*b00) * invDet
	})
end

function Matrix4:Unpack()
	return unpack(self.Components)
end

function Matrix4.__mul(leftMatrix, rightMatrix)
	local left = leftMatrix.Components

	local rightMatrixType = Class.GetType(rightMatrix)
	if rightMatrixType == "Matrix4" then
		local right = rightMatrix.Components

		return Matrix4.Create({
			-- Row 1
			left[1]*right[1]  + left[2]*right[5]  + left[3]*right[9]  + left[4]*right[13],
			left[1]*right[2]  + left[2]*right[6]  + left[3]*right[10] + left[4]*right[14],
			left[1]*right[3]  + left[2]*right[7]  + left[3]*right[11] + left[4]*right[15],
			left[1]*right[4]  + left[2]*right[8]  + left[3]*right[12] + left[4]*right[16],

			-- Row 2
			left[5]*right[1]  + left[6]*right[5]  + left[7]*right[9]  + left[8]*right[13],
			left[5]*right[2]  + left[6]*right[6]  + left[7]*right[10] + left[8]*right[14],
			left[5]*right[3]  + left[6]*right[7]  + left[7]*right[11] + left[8]*right[15],
			left[5]*right[4]  + left[6]*right[8]  + left[7]*right[12] + left[8]*right[16],

			-- Row 3
			left[9]*right[1]  + left[10]*right[5]  + left[11]*right[9]  + left[12]*right[13],
			left[9]*right[2]  + left[10]*right[6]  + left[11]*right[10] + left[12]*right[14],
			left[9]*right[3]  + left[10]*right[7]  + left[11]*right[11] + left[12]*right[15],
			left[9]*right[4]  + left[10]*right[8]  + left[11]*right[12] + left[12]*right[16],

			-- Row 4
			left[13]*right[1]  + left[14]*right[5]  + left[15]*right[9]  + left[16]*right[13],
			left[13]*right[2]  + left[14]*right[6]  + left[15]*right[10] + left[16]*right[14],
			left[13]*right[3]  + left[14]*right[7]  + left[15]*right[11] + left[16]*right[15],
			left[13]*right[4]  + left[14]*right[8]  + left[15]*right[12] + left[16]*right[16],
		})
	elseif rightMatrixType == "Vector3" then
		x, y, z = rightMatrix:Unpack()

		return Vector3.Create(
			left[1]*x + left[2]*y + left[3]*z + left[4],
        	left[5]*x + left[6]*y + left[7]*z + left[8],
        	left[9]*x + left[10]*y + left[11]*z + left[12]
		)
	elseif rightMatrixType == "Vector2" then
		x, y = rightMatrix:Unpack()

		return Vector2.Create(
			left[1]*x + left[2]*y + left[4],
        	left[5]*x + left[6]*y + left[8]
		)
	elseif rightMatrixType == "number" then
		return Matrix4.Create({
			left[1]*rightMatrix, left[2]*rightMatrix, left[3]*rightMatrix, left[4]*rightMatrix,
			left[5]*rightMatrix, left[6]*rightMatrix, left[7]*rightMatrix, left[8]*rightMatrix,
			left[9]*rightMatrix, left[10]*rightMatrix, left[11]*rightMatrix, left[12]*rightMatrix,
			left[13]*rightMatrix, left[14]*rightMatrix, left[15]*rightMatrix, left[16]*rightMatrix,
		})
	end
end

function Matrix4.__eq(leftMatrix, rightMatrix)
	local left = leftMatrix.Components
	local right = rightMatrix.Components

	return
		left[1] == right[1] and left[2] == right[2] and left[3] == right[3] and left[4] == right[4] and
		left[5] == right[5] and left[6] == right[6] and left[7] == right[7] and left[8] == right[8] and
		left[9] == right[9] and left[10] == right[10] and left[11] == right[11] and left[12] == right[12] and
		left[13] == right[13] and left[14] == right[14] and left[15] == right[15] and left[16] == right[16]
end

function Matrix4.__tostring(matrix)
	return string.format(
		"\n|%-.3f, %-.3f, %-.3f, %-.3f|\n|%-.3f, %-.3f, %-.3f, %-.3f|\n|%-.3f, %-.3f, %-.3f, %-.3f|\n|%-.3f, %-.3f, %-.3f, %-.3f|\n",
		unpack(matrix.Components)
	)
end

Class.CreateClass(Matrix4, "Matrix4")

Matrix4.Zero = Matrix4.Create()
Matrix4.Identity = Matrix4.CreateIdentity()

return Class.CreateClass(Matrix4, "Matrix4")