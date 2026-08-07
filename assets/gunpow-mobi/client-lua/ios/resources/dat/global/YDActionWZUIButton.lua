--BtnActionManager.lua
--@brief	按钮动作的管理
--@date  	2015/12/24
--@author 	张铭
--@note 	管理按钮按下和松开的动作

YDActionWZUIButton = {
	ActionList = "Normal",
	t_scale = {}, --节点的表
}


function YDActionWZUIButton:onTouchBeginNormal(element)
	WZLog("YDActionWZUIButton:onTouchBeginNormal:", element)
	for k,v in pairs(self.t_scale) do
		if v.element == element then
			WZLog("YDActionWZUIButton:onTouchBeginNormal22:", element)
			local button = WZUIButton:luaTo(element)
			button:stopAllActions()
			button:setScaleX(v.n_scaleX)
			button:setScaleY(v.n_scaleY)
			button.CallLuaDoneFunction(button)
			table.remove(self.t_scale,k)
			return
		end
	end
	local elementInfo = {}
	elementInfo.element = element
	elementInfo.n_scaleX = element:getScaleX()
	elementInfo.n_scaleY = element:getScaleY()
	elementInfo.b_action = true
	table.insert(self.t_scale, elementInfo)
	element:runAction(CCScaleTo:create(0.1,1.1*elementInfo.n_scaleX,1.1*elementInfo.n_scaleY))
	local button = WZUIButton:luaTo(element)
	button:CallLuaPushFunction()
end 

function YDActionWZUIButton:onTouchEndedNormal(element)
	WZLog("YDActionWZUIButton:onTouchEndedNormal:", element)
	local button = WZUIButton:luaTo(element)
	self:_upAction(element,button.CallLuaDoneFunction,button)
end

function YDActionWZUIButton:onTouchMoveOutNormal(element)
	WZLog("YDActionWZUIButton:onTouchMoveOutNormal:", element)
	self:_upAction(element)
end

function YDActionWZUIButton:onTouchCancelNormal(element)
	WZLog("YDActionWZUIButton:onTouchCancelNormal:", element)
	self:_upAction(element)
end


--@brief 按钮松开，超出范围，取消的动作
--@param element:节点
--@param funObj,luaTableObj 回调函数及其所在表
function YDActionWZUIButton:_upAction(element,funObj, luaTableObj)
	local n_scaleX = 1
	local n_scaleY = 1
	local b_canAction = false
	local nTag = -1
	for k,v in pairs(self.t_scale) do
		if v.element == element then
			n_scaleX = v.n_scaleX
			n_scaleY = v.n_scaleY
			b_canAction = v.b_action
			-- if not b_canAction then
			-- 	table.remove(self.t_scale,k)
			-- end
			v.b_action = false
			break
		end
	end
	if not b_canAction then
	 	return
	end
	local actionArray = CCArray:create()
	if funObj ~= nil then
		actionArray:addObject(CCCallFuncN:create(function() funObj(luaTableObj) end))
	end
	actionArray:addObject(CCScaleTo:create(0.07,0.95*n_scaleX,0.95*n_scaleY))
	actionArray:addObject(CCScaleTo:create(0.07,1.1*n_scaleX,1.1*n_scaleY))
	actionArray:addObject(CCScaleTo:create(0.07,1.0*n_scaleX,1.0*n_scaleY))
	actionArray:addObject(CCCallFuncN:create(function() 
		for k,v in pairs(self.t_scale) do
			if v.element == element then
				WZLog("YDActionWZUIButton:_upAction remove:",v.element)
				table.remove(self.t_scale,k)
			end
		end
	 end))
	local repH = CCSequence:create(actionArray)
	element:runAction(repH)
end
