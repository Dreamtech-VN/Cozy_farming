
local ElementFactory = {}

function ElementFactory:createElement(element)

	local theType = tonumber(element.type)
	local setter = PropertySetterFactory:getPropertySetter(theType)

	if nil == setter then
		print("setter is nil:", theType)
	end

	local node = nil
	if ElementType.Edit_CCNode == theType then
		node = CCNode:create()
	elseif ElementType.Edit_Sprite == theType then
		local defaultPath = element.texture
		node = CCSprite:create(defaultPath)
	elseif ElementType.Edit_Particle == theType then
		local path = element.particle
		node = CCParticleSystemQuad:create(path)
	elseif ElementType.Edit_WydAnim == theType then
		local path = element.file
		node = AnimationPlayer.new(path)
		node:play()
	elseif ElementType.Edit_Scale9Sprite == theType then
		local defaultPath = element.texture
		node = CCScale9Sprite:create(defaultPath)
	end

	if nil ~= node then
		for k, v in pairs(element) do
			setter:setValue(node, k, v)
		end
	end

	return node
end


rawset(_G, "ElementFactory", ElementFactory)
