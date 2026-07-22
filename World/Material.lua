local Material = {}

function Material.Create()
	local self = Class.CreateInstance(Object.Create(), Material)

	self._Colour = Vector4.Create(0.3, 0.3, 0.3, 1.0)
	self._ColourTexture = nil

	self._Glow = Vector4.Create(0, 0, 0, 0)
	self._GlowTexture = nil

	self._Metalness = 0
	self._MetalnessTexture = nil
	
	self._Roughness = 0.8
	self._RoughnessTexture = nil

	self._NormalScale = 1
	self._NormalTexture = nil

	self._OcclusionStrength = 1
	self._OcclusionTexture = nil

	self._UVShift = Vector2.Zero
	self._UVScale = Vector2.One

	self._AlphaCutoff = 0

	self._Buffer = lovr.graphics.newBuffer({
		{name = "Colour", type = "vec4"},
		{name = "Glow", type = "vec4"},
		{name = "Metalness", type = "float"},
		{name = "Roughness", type = "float"},
		{name = "NormalScale", type = "float"},
		{name = "OcclusionStrength", type = "float"},
		{name = "UVShift", type = "vec2"},
		{name = "UVScale", type = "vec2"},
		{name = "AlphaCutoff", type = "float"},
		layout = "std430"
	}, 1)
	self._Changed = Class.NIL

	return self
end

function Material:GetColour()
	return self._Colour
end

function Material:SetColour(colour)
	if colour ~= self._Colour then
		self._Colour = colour

		return true, colour
	end
end

function Material:GetColourTexture()
	return self._ColourTexture
end

function Material:SetColourTexture(texture)
	if texture ~= self._ColourTexture then
		self._ColourTexture = texture

		return true, texture
	end
end

function Material:GetGlow()
	return self._Glow
end

function Material:SetGlow(glow)
	if glow ~= self._Glow then
		self._Glow = glow

		return true, glow
	end
end

function Material:GetGlowTexture()
	return self._GlowTexture
end

function Material:SetGlowTexture(texture)
	if texture ~= self._GlowTexture then
		self._GlowTexture = texture

		return true, texture
	end
end

function Material:GetMetalness()
	return self._Metalness
end

function Material:SetMetalness(metalness)
	if metalness ~= self._Metalness then
		self._Metalness = metalness

		return true, metalness
	end
end

function Material:GetMetalnessTexture()
	return self._MetalnessTexture
end

function Material:SetMetalnessTexture(texture)
	if texture ~= self._MetalnessTexture then
		self._MetalnessTexture = texture

		return true, texture
	end
end

function Material:GetRoughness()
	return self._Roughness
end

function Material:SetRoughness(roughness)
	if roughness ~= self._Roughness then
		self._Roughness = roughness

		return true, roughness
	end
end

function Material:GetRoughnessTexture()
	return self._RoughnessTexture
end

function Material:SetRoughnessTexture(texture)
	if texture ~= self._RoughnessTexture then
		self._RoughnessTexture = texture

		return true, texture
	end
end

function Material:GetNormalScale()
	return self._NormalScale
end

function Material:SetNormalScale(strength)
	if strength ~= self._NormalScale then
		self._NormalScale = strength

		return true, strength
	end
end

function Material:GetNormalTexture()
	return self._NormalTexture
end

function Material:SetNormalTexture(texture)
	if texture ~= self._NormalTexture then
		self._NormalTexture = texture

		return true, texture
	end
end

function Material:GetOcclusionStrength()
	return self._OcclusionStrength
end

function Material:SetOcclusionStrength(strength)
	if strength ~= self._OcclusionStrength then
		self._OcclusionStrength = strength

		return true, strength
	end
end

function Material:GetOcclusionTexture()
	return self._OcclusionTexture
end

function Material:SetOcclusionTexture(texture)
	if texture ~= self._OcclusionTexture then
		self._OcclusionTexture = texture

		return true, texture
	end
end

function Material:GetUVShift()
	return self._UVShift
end

function Material:SetUVShift(shift)
	if shift ~= self._UVShift then
		self._UVShift = shift

		return true, shift
	end
end

function Material:GetUVScale()
	return self._UVScale
end

function Material:SetUVScale(scale)
	if scale ~= self._UVScale then
		self._UVScale = scale

		return true, scale
	end
end

function Material:GetAlphaCutoff()
	return self._AlphaCutoff
end

function Material:SetAlphaCutoff(cutoff)
	if cutoff ~= self._AlphaCutoff then
		self._AlphaCutoff = cutoff

		return true, cutoff
	end
end

function Material:GetBuffer()
	return self._Buffer
end

--[[DependsOn: Colour, Glow, Metalness, Roughness, NormalScale, NormalTexture, OcclusionStrength, UVShift, UVScale, AlphaCutoff]]--
function Material:GetChanged()
	return self._Changed == Class.NIL
end

function Material:SetChanged(changed)
	if changed ~= self._Changed then
		self._Changed = changed

		return true, changed
	end
end

function Material:Upload(forceUpload)
	if self.Changed or forceUpload then
		self._Buffer:setData({{
			{self._Colour:Unpack()},
			{self._Glow:Unpack()},
			self._Metalness,
			self._Roughness,
			self._NormalTexture and self._NormalScale or -1, -- Disable normal mapping if normal map isnt given
			self._OcclusionStrength,
			{self._UVShift:Unpack()},
			{self._UVScale:Unpack()},
			self._AlphaCutoff
		}})

		self.Changed = false
	end
end

function Material:SendToPass(pass)
	self:Upload(false)

	pass:send("_MaterialBuffer", self._Buffer)

	pass:send("MaterialColourTexture", self._ColourTexture or Thread.WhiteTexture)
	pass:send("MaterialGlowTexture", self._GlowTexture or Thread.WhiteTexture)
	pass:send("MaterialMetalnessTexture", self._MetalnessTexture or Thread.WhiteTexture)
	pass:send("MaterialRoughnessTexture", self._RoughnessTexture or Thread.WhiteTexture)
	pass:send("MaterialOcclusionTexture", self._OcclusionTexture or Thread.WhiteTexture)
	pass:send("MaterialNormalTexture", self._NormalTexture or Thread.BlackTexture)
end

function Material:Destroy()
	if not self._Destroyed then
		self._Colour = nil
		self._ColourTexture = nil

		self._Glow = nil
		self._GlowTexture = nil

		self._MetalnessTexture = nil

		self._RoughnessTexture = nil

		self._NormalTexture = nil

		self._OcclusionTexture = nil

		self._UVShift = nil
		self._UVScale = nil

		self._Buffer:release()
		self._Buffer = nil

		Object.Destroy(self)
	end
end

return Class.CreateClass(Material, "Material", Object, scriptpath())