--CellChatBubbleData.lua
--@brief	CellChatBubble的数据模块
--@date		2016/06/23
--@author	qixiang
--@note		聊天冒泡

CellChatBubble = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function CellChatBubble:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_sMsg = nil
	self.m_nTag = 0
	self.m_nPlayerId = nil
	self.m_nBubbleId = 0
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellChatBubble:_unInit()
	self.m_root = nil
	self.m_sMsg = nil
	self.m_nTag = nil
	self.m_nPlayerId = nil
	self.m_nBubbleId = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function CellChatBubble:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellChatBubble table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellChatBubble")
	assert(element, "CellChatBubble element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

--新增聊天信息
function CellChatBubble:addMsgToList(txtMsg,playerId,bubbleId)
	WZLog("CellChatBubble:addMsgToList = ",txtMsg)
	self.m_nPlayerId = playerId
	self.m_nBubbleId = bubbleId
	if txtMsg ~= nil and txtMsg ~= "" then
		self:updateMst(txtMsg)
	end
end

--添加聊天冒泡
--parentNode 父节点
--abs：绝对坐标
function CellChatBubble:showChatBubble(parentNode,absPS,bShowAll)
	WZLog("CellChatBubble:showChatBubble")
	if parentNode ~= nil then
		local cellChatBubble ,cellChatBubbleLuaObject = CellChatBubble:createElement()
		if bShowAll == nil or  bShowAll then
			cellChatBubble:setShowAll(true)
		end
		parentNode:addChild(cellChatBubble)
		if absPS ~= nil and absPS.x ~= nil then
			cellChatBubble:setAbsPosition(GlobalMethod:ccp(absPS.x,absPS.y))
		end
		return cellChatBubble,cellChatBubbleLuaObject
	end
	return nil
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

function CellChatBubble:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end



-------------------------------------私有方法模块End----------------------------------------
