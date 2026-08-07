
local Scale9SpritePropertySetter = {}


function Scale9SpritePropertySetter:setValue(node, propertyName, value)
	local propertyType = PropertyType.property_none
	
	if "texture" == propertyName then
		local frameCache = CCSpriteFrameCache:sharedSpriteFrameCache()
		local frame = frameCache:spriteFrameByName(value)
		if nil ~= frame then
			node:setSpriteFrame(frame)
		end
		propertyType = PropertyType.property_texture
	elseif "insetTop" == propertyName then
		node:setInsetTop(tonumber(value))
		propertyType = PropertyType.property_insetTop
	elseif "insetBottom" == propertyName then
		node:setInsetBottom(tonumber(value))
		propertyType = PropertyType.property_insetBottom
	elseif "insetLeft" == propertyName then
		node:setInsetLeft(tonumber(value))
		propertyType = PropertyType.property_insetLeft
	elseif "insetRight" == propertyName then
		node:setInsetRight(tonumber(value))
		propertyType = PropertyType.property_insetRight
	end
	
	if propertyType == PropertyType.property_none then
		propertyType = CCSpritePropertySetter:setValue(node, propertyName, value)
	end
	
  	return propertyType
end


rawset(_G, "Scale9SpritePropertySetter", Scale9SpritePropertySetter)
