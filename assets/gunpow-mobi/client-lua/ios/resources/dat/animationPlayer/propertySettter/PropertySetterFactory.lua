
local PropertySetterFactory = {}



function PropertySetterFactory:getPropertySetter(elementType)
	if ElementType.Edit_CCNode == elementType then
		return CCNodePropertySetter
	elseif ElementType.Edit_Sprite == elementType then
		return CCSpritePropertySetter
	elseif ElementType.Edit_Particle == elementType then
		return CCParticlePropertySetter
	elseif ElementType.Edit_WydAnim == elementType then
		return WydAnimPropertySetter
	elseif ElementType.Edit_Scale9Sprite == elementType then
		return Scale9SpritePropertySetter
	end
	return nil
end


rawset(_G, "PropertySetterFactory", PropertySetterFactory)
