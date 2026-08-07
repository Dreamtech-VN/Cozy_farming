--CellPrivateChatHead.lua
--@brief	CellPrivateChatHead的UI模块
--@date		2017/02/24
--@author	qixiang
--@note		私聊头像


-------------------------------------公有方法模块Begin--------------------------------------
--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellPrivateChatHead:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellPrivateChatHead:onExit(element)
	self:_unInit()
end

function CellPrivateChatHead:updateSelectStats()
	-- body
	WZLog("CellPrivateChatHead:updateSelectStats")
	if self.m_root == nil then return end
	local imgHeightLight = GetElement(self.m_root,"imgHeightLight_CellPrivateChatHead",WZUI9Image)
	local conRemove = GetElement(self.m_root,"conRemove_CellPrivateChatHead",WZUIContainer)
	if imgHeightLight then
		if self.m_bSelect then
		    imgHeightLight:setVisible(true)
		else
			imgHeightLight:setVisible(false)
		end
	end

	if not self.m_tData.bGM then
		conRemove:setVisible(true)
	else
		conRemove:setVisible(false)
	end
end

--更新头部形象
function CellPrivateChatHead:updateHead()
	-- body
	WZLog("CellPrivateChatHead:updateHead")
	if self.m_root == nil then return end
	local conPlayerHead = GetElement(self.m_root,"conPlayerHead_CellPrivateChatHead",WZUIContainer)
	local childElement = conPlayerHead:getChildByTag(1118)
	if childElement then
		childElement:removeFromParentAndCleanup(true)
	end
	local cellElement,cellLuaObject = CellHead:show(conPlayerHead,self.m_tData.head,self.m_tData.face,self.m_tData.sex,nil,GlobalMethod:ccp(0.5,0.29),self.m_tData.vipLevel,self.m_tData.headColor)
	cellElement:setTag(1118)
	if not self.m_bOnline then
		if cellLuaObject.m_tAnimNode then
			cellLuaObject.m_tAnimNode:setGrayRender(true)
		end
	else
		if cellLuaObject.m_tAnimNode then
			cellLuaObject.m_tAnimNode:setGrayRender(false)
		end
	end
end

function CellPrivateChatHead:updateOnlineStats()
	-- body
	WZLog("CellPrivateChatHead:updateOnlineStats")
	if self.m_root == nil or self.m_tData.bGM then return end
	local conPlayerHead = GetElement(self.m_root,"conPlayerHead_CellPrivateChatHead",WZUIContainer)
	if not self.m_tData.bGM and conPlayerHead then
		local childNode = conPlayerHead:getChildByTag(1118)
		if childNode then
			childNode = WZUIContainer:luaTo(childNode)
			if childNode then
				local cellLuaObject = childNode:getLuaObjectIndex()
				if cellLuaObject then
					if not self.m_bOnline then
						if cellLuaObject.m_tAnimNode then
							cellLuaObject.m_tAnimNode:setGrayRender(true)
						end
					else
						if cellLuaObject.m_tAnimNode then
							cellLuaObject.m_tAnimNode:setGrayRender(false)
						end
					end
				end
			end
		end
	end
end

function CellPrivateChatHead:updateRedPointStats()
	-- body
	WZLog("CellPrivateChatHead:updateRedPointStats =",self.m_bShowRedPoint)
	if self.m_root == nil then return end
	local imgRedPoint = GetElement(self.m_root,"imgRedPoint_CellPrivateChatHead",WZUIImage)
	if imgRedPoint then
		if self.m_bShowRedPoint then
		    imgRedPoint:setVisible(true)
		else
			imgRedPoint:setVisible(false)
		end
	end
end

function CellPrivateChatHead:onClickFastPriChat(element)
	-- body
	WZLog("CellPrivateChatHead:onClickFastPriChat")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local imgHeightLight = GetElement(self.m_root,"imgHeightLight_CellPrivateChatHead",WZUI9Image)
	if imgHeightLight:isVisible() then
		return
	end
	local parent = element:getParent()
	local tag = parent:getTag()
	self.m_bSelect = true
	imgHeightLight:setVisible(true)
	local imgRedPoint = GetElement(self.m_root,"imgRedPoint_CellPrivateChatHead",WZUIImage)
	imgRedPoint:setVisible(false)
	local conRemove = GetElement(self.m_root,"conRemove_CellPrivateChatHead",WZUIContainer)
	if not self.m_tData.bGM then
		conRemove:setVisible(true)
	else
		conRemove:setVisible(false)
	end

	if self.m_luaCallback and self.m_luaCallfun then
		self.m_luaCallfun(self.m_luaCallback,tag)
	end
end

--@brief  加载数据
function CellPrivateChatHead:onLoadData(element)
	WZLog("CellPrivateChatHead:onLoadData")
	local txtPlayerName = GetElement(self.m_root,"txtPlayerName_CellPrivateChatHead",WZUILabelTTF)
	local txtPlayerLevel = GetElement(self.m_root,"txtPlayerLevel_CellPrivateChatHead",WZUILabelTTF)
	local imgVipLevel = GetElement(self.m_root,"imgVipLevel_CellPrivateChatHead",WZUIImage)
	local txtVip = GetElement(self.m_root,"txtVip_CellPrivateChatHead",WZUILabelAtlasFont)
	local conPlayerHead = GetElement(self.m_root,"conPlayerHead_CellPrivateChatHead",WZUIContainer)
	local img9Bg = GetElement(self.m_root,"img9Bg_CellPrivateChatHead",WZUI9Image)

	if self.m_tData.bGM then
		txtPlayerName:setText(LocalStrings.ASSISTANT2)
		txtPlayerLevel:setText("GM")
		local image = WZUIImage:create()
		image:setFile("battle/head/npc_0002.png")
		image:setUseOriginSize(true)
		image:setScale(0.8)
		conPlayerHead:addChild(image)
	else
		if self.m_tData.name then
		    txtPlayerName:setText(self.m_tData.name)
		end

		WZLog("CellPrivateChatHead:onLoadData", self.m_tData.name, CacheCenter:getPlayerInfo().masterName)
		local tMasterName = json.decode(CacheCenter:getPlayerInfo().masterName)
		for i, name in pairs(tMasterName) do
			if self.m_tData.name == name then
				img9Bg:setFile("ui/chat/chat_private_player_blue.png")
				break 
			end
		end

		if self.m_tData.name == CacheCenter:getPlayerInfo().mateName then
			img9Bg:setFile("ui/chat/chat_private_player_red.png")
		end

		if self.m_tData.playerLevel then
			txtPlayerLevel:setText("Lv" .. self.m_tData.playerLevel)
		end

		local cellElement ,cellLuaObject = CellHead:show(conPlayerHead,self.m_tData.head,self.m_tData.face,self.m_tData.sex,nil,GlobalMethod:ccp(0.5,0.29),self.m_tData.vipLevel,self.m_tData.headColor)
		cellElement:setTag(1118)
		self:updateOnlineStats()
	end
	self:updateSelectStats()
	self:updateRedPointStats()
end

--删除私聊对象
function CellPrivateChatHead:onClickRemove(element)
	WZLog("CellPrivateChatHead:onClickRemove")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_luaRemoveCallback and self.m_luaRemoveCallbackFun then
		self.m_luaRemoveCallbackFun(self.m_luaRemoveCallback,self.m_tData.id)
	end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
