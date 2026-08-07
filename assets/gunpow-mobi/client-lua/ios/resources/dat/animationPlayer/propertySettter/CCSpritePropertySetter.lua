
local CCSpritePropertySetter = {}

local m_srcValMap = {}
m_srcValMap[0]		= 0
m_srcValMap[1]		= 1
m_srcValMap[2]		= 0x0302
m_srcValMap[3]		= 0x0303
m_srcValMap[4]		= 0x0304
m_srcValMap[5]		= 0x0305
m_srcValMap[6]		= 0x0306
m_srcValMap[7]		= 0x0307
m_srcValMap[8]		= 0x0308


local m_dstValMap = {}
m_dstValMap[0]		= 0
m_dstValMap[1]		= 1
m_dstValMap[2]		= 0x0300
m_dstValMap[3]		= 0x0301
m_dstValMap[4]		= 0x0302
m_dstValMap[5]		= 0x0303
m_dstValMap[6]		= 0x0304
m_dstValMap[7]		= 0x0305


function CCSpritePropertySetter:setValue(node, propertyName, value)
	local propertyType = CCNodePropertySetter:setValue(node, propertyName, value)
	if propertyType == PropertyType.property_none then

		if "color" == propertyName then
			local arr = splitStr(value, ",")
			node:setColor(ccc3(tonumber(arr[1]), tonumber(arr[2]), tonumber(arr[3]) ))
			node:setOpacity(tonumber(arr[4]) )
			propertyType = PropertyType.property_color
		elseif "texture" == propertyName then
			local frameCache = CCSpriteFrameCache:sharedSpriteFrameCache()
			local frame = frameCache:spriteFrameByName(value)
			if nil ~= frame then
				node:setSpriteFrame(frame)
			else
				local texture = CCTextureCache:sharedTextureCache():addImage(value)
				node:setTexture(texture)
			end
			propertyType = PropertyType.property_texture
		elseif "blend_dst" == propertyName then
			local blend = node:getBlendFunc()
			blend.dst = m_dstValMap[tonumber(value)]
			node:setBlendFunc(blend)
			propertyType = PropertyType.property_blend

		elseif "blend_src" == propertyName then
			local blend = node:getBlendFunc()
			blend.src = m_srcValMap[tonumber(value)]
			node:setBlendFunc(blend)
			propertyType = PropertyType.property_blend
		elseif "blend" == propertyName then
			local arr = splitStr(value, ",")
			local blend = ccBlendFunc()
			blend.src = m_srcValMap[tonumber(arr[1])]
			blend.dst = m_dstValMap[tonumber(arr[2])]
			node:setBlendFunc(blend)
			propertyType = PropertyType.property_blend
		end
		
	end


  	return propertyType
end


rawset(_G, "CCSpritePropertySetter", CCSpritePropertySetter)


 