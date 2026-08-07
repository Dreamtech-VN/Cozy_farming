
local AnimationParser = luaClass("AnimationParser")

function AnimationParser:ctor(path, elementFactory)
	self.version = 1--解析器版本
	local fileUtil = CCFileUtils:sharedFileUtils()
	local filePath = fileUtil:fullPathForFilename(path)
	local jsonStr = CCString:createWithContentsOfFile(filePath):getCString()
    self.factory = elementFactory
	self.model = json.decode(jsonStr)
	-- print("self.model:::", self.model)--版本号
	--排序所有的frame
	for _, animationConfig in ipairs(self.model.animationGroup.animations) do
		for _, animation in ipairs(animationConfig.animation) do
			for _, action in ipairs(animation.action) do
				self:_sortFrame(action)
			end
		end
	end
 
end

function AnimationParser:getModel()
	return self.model
end

function AnimationParser:_sortFrame(actionModel)
	if nil == actionModel.frame then
		return
	end
	local frameLen = #actionModel.frame
	for i = 1, frameLen do
		for k = i + 1, frameLen do
			local a = actionModel.frame[i]
			local b = actionModel.frame[k]

			if tonumber(a.index) > tonumber(b.index) then
				local _tmp = actionModel.frame[i]
				actionModel.frame[i] = b
				actionModel.frame[k] = _tmp
			end

		end
	end
end

function AnimationParser:parserElement(container, elementIdDict)
	self.elementIdDict = elementIdDict
	local elements = self.model.elements
	self:_parserElement(container, elements)
end

function AnimationParser:_parserElement(parent, elementModelList)
	for i, elementModel in ipairs(elementModelList) do
		local node = self.factory:createElement(elementModel)
		if nil ~= node then
			self.elementIdDict[elementModel.id] = {node, elementModel}
			parent:addChild(node)
			self:_parserElement(node, elementModel.elements)
		end
	end
end

function AnimationParser:getElementAnimationDict(frameCallback) 
	local elementAnimationDict = {}
	local maxDuration = 0
	local fps = 30
	local defaultAnimationConfigName = self.model.animationGroup.default
	local animations = self.model.animationGroup.animations
	local animationConfigModel = nil
	for i, _animationConfigModel in ipairs(animations) do
		if defaultAnimationConfigName == _animationConfigModel.name then
			animationConfigModel = _animationConfigModel
			break
		end
	end 
	if nil == animationConfigModel then
		return elementAnimationDict, maxDuration, fps, false
	end 
   	fps = tonumber(animationConfigModel.fps)
	for i, _animationModel in ipairs(animationConfigModel.animation) do
		 
		local spawnList, duration = self:_createAction(frameCallback, _animationModel, fps) 
		if duration > maxDuration then
			maxDuration = duration
		end
		elementAnimationDict[_animationModel.elementId] = spawnList
		 
	end

	local isLoop = animationConfigModel.loop == "1" 
	return elementAnimationDict, maxDuration, fps, isLoop
end

function AnimationParser:_createAction(frameCallback, animationModel, fps) 
	local maxFrameIndex = 0
	local spawnArr = CCArray:create()
	for i, actionModel in ipairs(animationModel.action) do
		local animationType = tonumber(actionModel.type )
		local lastIndex = 0
		local frameList = actionModel.frame

		local array = CCArray:create()
		for k, frameModel in ipairs(actionModel.frame or {}) do
			local index = tonumber(frameModel.index)
			local duration = (frameModel.index - lastIndex + 1) / fps 
			local action = self:_createActionByFrame(frameCallback, frameModel, animationType, duration)
			if index > maxFrameIndex then
				maxFrameIndex = index
			end
			lastIndex = index
			if nil ~= action then
				array:addObject(action)
			end
		end
	 	if 0 < array:count() then
			local sequence = CCSequence:create(array)
			spawnArr:addObject(sequence)
		end

	end
	local allDuration = (maxFrameIndex + 1) / fps
	return spawnArr, allDuration
end

-- AnimationParser.ignorePropertySet = {
-- 	["index"] = true,
-- 	["name"] = true,
-- 	["zorder"] = true,
-- }

-- AnimationType.MoveTo 	= 1
-- AnimationType.ScaleTo 	= 2
-- AnimationType.ColorTo 	= 3
-- AnimationType.OpacityTo = 4
-- AnimationType.Animate 	= 5
-- AnimationType.TintTo 	= 6
-- AnimationType.RotateTo 	= 7
-- AnimationType.SetFreame = 8--lua 版不支持
function AnimationParser:_createActionByFrame(frameCallback, frameModel, animationType, duration)
	if "1" == frameModel.blankFrame then--是否空白帧
		return CCDelayTime:create(duration)
	end
	if animationType == AnimationType.MoveTo then
		local pox = frameModel.positionX
		local poy = frameModel.positionY
		if nil == pox or nil == poy then
			return nil
		end
		return CCMoveTo:create(duration, CCPoint(pox, poy))
	elseif animationType == AnimationType.ScaleTo then
		local scaX = frameModel.scaleX
		local scaY = frameModel.scaleY
		if nil == scaX or nil == scaY then
			return nil
		end
		return CCScaleTo:create(duration, scaX, scaY)
	elseif animationType == AnimationType.RotateTo then
		local rotation = frameModel.rotation
		return CCRotateTo:create(duration, rotation)
	elseif animationType == AnimationType.TintTo then
		local color = frameModel.color
		local arr = splitStr(color, ",") 
		local _t = CCArray:create()
		_t:addObject( CCTintTo:create(duration, tonumber(arr[1]), tonumber(arr[2]), tonumber(arr[3])) )
		_t:addObject( CCFadeTo:create(duration, tonumber(arr[4])) )
		return CCSpawn:create(_t)
	elseif animationType == AnimationType.Callback then
		if nil == frameCallback then
			return nil
		end
		local flag = frameModel.flag
		local _t = CCArray:create()
		_t:addObject( CCDelayTime:create(duration) )
		_t:addObject( CCCallFunc:create(function()
				frameCallback(flag)
			end ))
		return CCSequence:create(_t)
	end

	if nil == frameModel.frameActions then
		return nil
	end

	for i, frameActionModel in ipairs(frameModel.frameActions) do

		if "animate" == frameActionModel.name then
	        local animFrames = CCArray:create()

	        local frameCache = CCSpriteFrameCache:sharedSpriteFrameCache()
	        local textureCache = CCTextureCache:sharedTextureCache()
	        for i, param in ipairs(frameActionModel.params) do
	        	 
	        	 
        		local spriteFrame = frameCache:spriteFrameByName(param)
	        	if nil ~= spriteFrame then 
	        		animFrames:addObject(spriteFrame)
	        	else
	        		local texture = textureCache:addImage(param)
	        		if nil ~= texture then
		        		local contentSize = texture:getContentSize()
		        		local rect = CCRectMake(0, 0, contentSize.width, contentSize.height)
		        		local frame = CCSpriteFrame:createWithTexture(texture, rect)
		        		animFrames:addObject(frame)
		        	end
	        	end
	    	end
	    	local delay = duration / animFrames:count()
	        local animation = CCAnimation:createWithSpriteFrames(animFrames, delay)
	        local animate = CCAnimate:create(animation)
	        return animate
		end
	end

	return nil
end

rawset(_G, "AnimationParser", AnimationParser)
