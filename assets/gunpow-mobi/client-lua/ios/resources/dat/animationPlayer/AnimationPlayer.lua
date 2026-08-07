local AnimationPlayer = luaClass("AnimationPlayer", function() 
		local node = CCNode:create()
		return node
	end)

function AnimationPlayer:ctor(path) 
	print("animationPlayer:::::::", path)
	self.m_frameCallback = nil
	self.m_bPlaying = nil
	self.m_parser = AnimationParser.new(path, ElementFactory)
	self._container = CCNode:create()
	self.elementIdDictStorage = {}
	self.m_parser:parserElement(self._container, self.elementIdDictStorage)
	self:addChild(self._container)
end

function AnimationPlayer:getContainer()
	return self._container
end

function AnimationPlayer:_stopAllElementAction()
	for id, item in pairs(self.elementIdDictStorage) do
		local node, model = unpack(item)
		node:stopAllActions()
	end
end

function AnimationPlayer:setAnimation(name)
	local model = self.m_parser:getModel()
	model.animationGroup.default = name
end

--[[
	callback(stringFlag)
]]
function AnimationPlayer:setCallbackFunc(callback)
	self.m_frameCallback = callback
end

function AnimationPlayer:play()
 	self._container:stopAllActions()
	local elementActionDict, maxDuration, fps, isLoop = self.m_parser:getElementAnimationDict(self.m_frameCallback)
	

	if 0 >= maxDuration then
		return
	end
	local frameDuration = 1.0 / fps
	if maxDuration > frameDuration then
		maxDuration = maxDuration - frameDuration
	end

	local array = CCArray:create() 
	array:addObject(CCDelayTime:create(maxDuration))
	array:addObject(CCCallFunc:create(function()
			if isLoop then
				self:play()
			else
				self.m_bPlaying = false;
			end
		end))

	local action = CCSequence:create(array)
	self._container:runAction(action) 
	 

	for id, item in pairs(self.elementIdDictStorage) do
		local node, elementModel = unpack(item)
		local elementType = tonumber(elementModel.type)
		local setter = PropertySetterFactory:getPropertySetter(elementType)
		if nil ~= setter then
			for k, v in pairs(elementModel) do
				setter:setValue(node, k, v)
			end
		end

		if elementType == ElementType.Edit_WydAnim then
			node:play()
		end
	end

	for elementId, spawnList in pairs(elementActionDict) do
		local item = self.elementIdDictStorage[elementId] 
		if nil ~= item and 0 < spawnList:count() then
			local node, model = unpack(item) 
			local spawnAction = CCSpawn:create(spawnList)
			node:stopAllActions()
			node:runAction(spawnAction)
		end
	end

	self.m_bPlaying = true

end

function AnimationPlayer:isPlaying()
	return self.m_bPlaying
end

function AnimationPlayer:stop()
	self._container:_stopAllElementAction()
	self:stopAllActions()
	self.m_bPlaying = false
end

function AnimationPlayer:pause()
	local actionMgr = CCDirector:sharedDirector():getActionManager() 
	actionMgr:pauseTarget(self._container) 
	for id, item in pairs(self.elementIdDictStorage) do
		local node, elementModel = unpack(item)
		local elementType = tonumber(elementModel.type)
		actionMgr:pauseTarget(node)
		if elementType == ElementType.Edit_WydAnim then
			node:pause()
		end

	end

	self.m_bPlaying = false
end

function AnimationPlayer:resume()
	local actionMgr = CCDirector:sharedDirector():getActionManager() 
	actionMgr:resumeTarget(self._container)

	for id, item in pairs(self.elementIdDictStorage) do
		local node, elementModel = unpack(item)
		local elementType = tonumber(elementModel.type)
		actionMgr:resumeTarget(node)
		if elementType == ElementType.Edit_WydAnim then
			node:resume()
		end

	end
	self.m_bPlaying = true
end


local CreateAnimationPlayer = function(parent, filePath)
	local interface = {}
	local player = AnimationPlayer.new(filePath)
	player:play()
	parent:addChild(player) 
	return player
end

rawset(_G, "AnimationPlayer", AnimationPlayer)
rawset(_G, "CreateAnimationPlayer", CreateAnimationPlayer)
