
local CCParticlePropertySetter = {}


function CCParticlePropertySetter:setValue(node, propertyName, value)
	local propertyType = CCSpritePropertySetter:setValue(node, propertyName, value)
	
  	return propertyType
end


rawset(_G, "CCParticlePropertySetter", CCParticlePropertySetter)
