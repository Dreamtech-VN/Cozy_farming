
local CCNodePropertySetter = {}

function CCNodePropertySetter:setValue(node, propertyName, value)
	local propertyType = PropertyType.property_none

	if "anchorPoint" == propertyName then
		if "0" == value then
			node:ignoreAnchorPointForPosition(true)	
		else
			node:ignoreAnchorPointForPosition(false)
		end
		propertyType = PropertyType.property_IgnoreAnchorpoint
	elseif "anchorPointX" == propertyName then
		local point = node:getAnchorPoint()
		point.x = tonumber(value) 
		node:setAnchorPoint(point)
		propertyType = PropertyType.property_anchorpoint
	elseif "anchorPointY" == propertyName then
		local point = node:getAnchorPoint()
		point.y = tonumber(value)
		node:setAnchorPoint(point)
		propertyType = PropertyType.property_anchorpoint
	elseif "positionX" == propertyName then
		node:setPositionX(tonumber(value))
		propertyType = PropertyType.property_position
  	elseif "positionY" == propertyName then
  		node:setPositionY(tonumber(value))
		propertyType = PropertyType.property_position
 	elseif "width" == propertyName then
 		local size = node:getContentSize()
 		size.width = tonumber(value)
 		node:setContentSize(size)
 		propertyType = PropertyType.property_size
 	elseif "height" == propertyName then
 		local size = node:getContentSize()
 		size.height = tonumber(value)
 		node:setContentSize(size)
 		propertyType = PropertyType.property_size
 	elseif "scaleX" == propertyName then
 		node:setScaleX(tonumber(value))
 		propertyType = PropertyType.property_scale
	elseif "scaleY" == propertyName then
 		node:setScaleY(tonumber(value))
 		propertyType = PropertyType.property_scale
  	elseif "rotation" == propertyName then
  		node:setRotation(tonumber(value))
  		propertyType = PropertyType.property_rotation
  	elseif "skewX" == propertyName then
  		node:setSkewX(tonumber(value))
  		propertyType = PropertyType.property_skew
  	elseif "skewY" == propertyName then
  		node:setSkewX(tonumber(value))
  		propertyType = PropertyType.property_skew
  	end
  	
  	return propertyType
end

rawset(_G, "CCNodePropertySetter", CCNodePropertySetter)
