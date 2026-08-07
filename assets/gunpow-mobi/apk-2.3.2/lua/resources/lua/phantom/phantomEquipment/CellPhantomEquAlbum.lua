--CellPhantomEquAlbum.lua
--@brief	CellPhantomEquAlbum的UI模块
--@date		2021/05/11
--@author	yrd
--@note		幻化装备图鉴子项


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellPhantomEquAlbum:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellPhantomEquAlbum:onExit(element)
	self:_unInit()
end

--@brief	加载动画
function CellPhantomEquAlbum:onEnterTransitionDidFinish(element)
	self:updateUI()
end

--@brief	加载动画
function CellPhantomEquAlbum:updateUI()
    local txtSuitName = GetElement(self.m_root,"txtSuitName_CellPhantomEquAlbum",WZUILabelTTF)
    txtSuitName:setText(self.m_tData.data.name)

    local imgCost = GetElement(self.m_root,"imgCost_CellPhantomEquAlbum",WZUIImage)
    local txtCost = GetElement(self.m_root,"txtCost_CellPhantomEquAlbum",WZUILabelTTF)
	local tItemInfo = GDatatab_item["id_"..self.m_tData.data.gift[1][1]]
	imgCost:setFile(tItemInfo.icon)
	txtCost:setText(self.m_tData.data.gift[1][2])

	self.m_tequipmentCObj = {}
	for i=1,7 do
    	local conSuitItem = GetElement(self.m_root,"conSuitItem"..i.."_CellPhantomEquAlbum",WZUIContainer)
    	conSuitItem:removeAllChildrenWithCleanup(true)

		if self.m_tData.data.items[1][i] then
			local cellElement,tLuaObj = CellGoodItem:createElement()
			if cellElement ~= nil and tLuaObj ~= nil then
				cellElement:setTag(i-1)
				tLuaObj:setCellGoodLocalId(self.m_tData.data.items[1][i],2)
				tLuaObj:setItemClickFun(self,self.onItemClick)
				conSuitItem:addChild(cellElement)

				self.m_tequipmentCObj[i] = tLuaObj

				conSuitItem:enableSchedule("_checkOwned")
			end
		end

    	local btnGetReward = GetElement(self.m_root,"btnGetReward_CellPhantomEquAlbum",WZUIButton)
		local conCost = GetElement(self.m_root,"conCost_CellPhantomEquAlbum",WZUIContainer)
		conCost:setRelativePosition(GlobalMethod:ccp(1,0.5))
		if self.m_tData.status == 0 then
			btnGetReward:setVisible(false)
		elseif self.m_tData.status == 1 then
			btnGetReward:setVisible(true)
			btnGetReward:setTouchEnable(true)
			conCost:setRelativePosition(GlobalMethod:ccp(0.9,0.5))
		elseif self.m_tData.status == 2 then
			btnGetReward:setVisible(true)
			btnGetReward:setTouchEnable(false)
			conCost:setRelativePosition(GlobalMethod:ccp(0.9,0.5))
		end
	end
end

--@brief	点击合成界面合成后物品回调
function CellPhantomEquAlbum:onItemClick(luaTable,tag,tData)
	WZLog("CellPhantomEquAlbum:onItemClick")
	local conSuit = GetElement(WndPhantomEquAlbum.m_root,"conSuit_WndPhantomEquAlbum",WZUIContainer)
	WndItemInfo:onCloseClick()
	WndItemInfo:showInfo(luaTable.m_root,conSuit,1,tData,true)
end

--@brief	检查是否已拥有
function CellPhantomEquAlbum:_checkOwned(element)
	element:disableSchedule()
	local tag = element:getTag()
	local tPastEquipList = WndPhantomEquipment:getPastEquipList()
	for i=1,#tPastEquipList do
		if self.m_tData.data.items[1][tag] == tPastEquipList[i] then
			self.m_tequipmentCObj[tag]:addSidebarOwn()
			break
		end
	end
end

--@brief	点击领取按钮回调
function CellPhantomEquAlbum:onClickGetReward(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	ProtocolProcessorPhantom:send_SHAPE_GetShapeEquipReward(self.m_tData.data.id)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
