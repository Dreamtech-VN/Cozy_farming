

local WydAnimPropertySetter = {}


local transSizeProSet = {
	["width"]	 	= true,
	["height"]	 	= true,
	["anchorPoint"] = true,
	["anchorPointX"] = true,
	["anchorPointY"] = true, 
}

function WydAnimPropertySetter:setValue(node, propertyName, value)
	local propertyType = PropertyType.property_none

	if "width" == propertyName then
 		local size = node:getContentSize()
 		size.width = tonumber(value)
 		node:setContentSize(size)
 		propertyType = PropertyType.property_size
 	elseif "height" == propertyName then
 		local size = node:getContentSize()
 		size.height = tonumber(value)
 		node:setContentSize(size)
 		propertyType = PropertyType.property_size
 	end
 	if propertyType == PropertyType.property_none then
		propertyType = CCNodePropertySetter:setValue(node, propertyName, value)
	end


	if transSizeProSet[propertyName] then
		local size = node:getContentSize()
		local anchorPoint = node:getAnchorPoint()
		if node:isIgnoreAnchorPointForPosition() then
			anchorPoint = CCPoint(0, 0)
		end
		node:getContainer():setPosition(CCPoint(size.width * anchorPoint.x, size.height * anchorPoint.y ))
	end
	
	
  	return propertyType
end


rawset(_G, "WydAnimPropertySetter", WydAnimPropertySetter)

