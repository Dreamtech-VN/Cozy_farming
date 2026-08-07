--WndSellList.lua
--@brief	WndSellList的UI模块
--@date		2015/07/03
--@author	zsq
--@note		出售物品列表


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndSellList:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndSellList:onExit(element)
	self:_unInit()
end

--@brief	进入装备商店
function WndSellList:onStore(element)
	WZLog("WndSellList:onStore")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndStore:showStoreByType(8)
end

--@brief	出售按钮
function WndSellList:onSale(element)
	WZLog("WndSellList:onSale")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_tLeft == nil or #self.m_tLeft == 0 then
		MsgBoxManager:showTipBox(LocalStrings.PUT_SELL_MATERIAL)
		return 
	end
	--有时限装备时，要至少保留一件同类型装备
	for i=1,#self.m_tLeft do
		local itemId = self.m_tLeft[i].basicInfo.id
		if self.m_tLeft[i].basicInfo.main_type == 4 and WndSellList:getOwnLimitNum(itemId) >= 1 and
		(WndSellList:getInSaleNum(itemId) + WndSellList:getOwnLimitNum(itemId)) >= WndSellList:getOwnNum(itemId) then
			MsgBoxManager:showTipBox(LocalStrings.LIMITEQUIP2)
			return 
		end
	end

	local warn = false
    
    self.m_vItemID = WZLuaVector_int_:create()
    self.m_vItemNum = WZLuaVector_int_:create()
    self.m_vItemID:retain()
    self.m_vItemNum:retain()
    
    local bSale = false
    for i,data in pairs(self.m_tLeft) do 
        if data == nil then
            break
        else
            bSale = true

            self.m_vItemID:push(data.playerItemId)
            self.m_vItemNum:push(data.lastNum)
			WZLog("WndSellList:onSale:",data.playerItemId,data.lastNum)
			if data.basicInfo.quality >= 3 then warn = true end
			if data.extraInfo ~= nil and data.extraInfo.strongLevel ~= nil and data.extraInfo.strongLevel >= 20 then warn = true end
        end

    end
	
	if warn then
		local msg1 = LocalStrings.SELL_CONFIRM	
		MsgBoxManager:showConfirmBoxWithBg(msg1, self, self.sellConfirm, MSGBOXLEVEL_HIGH, {[MSGBOXUICFG_USEFREETXT] = true})
		return
	end
    
    if bSale == false then
        return
    end
    
    self:startLoading()        
	ProtocolProcessorRecycling:send_PLAYERITEM_RecycleItem(self.m_vItemID, self.m_vItemNum )
	WZLog(Serialize(VectorToTable(self.m_vItemID)),Serialize(VectorToTable(self.m_vItemNum)))
    self:reduceRef()

	self.m_tLeft = {}
    WndSell.m_tSellList = {}
end

function WndSellList:sellConfirm()
    self:startLoading()

    ProtocolProcessorRecycling:send_PLAYERITEM_RecycleItem(self.m_vItemID, self.m_vItemNum )
    WZLog(Serialize(VectorToTable(self.m_vItemID)),Serialize(VectorToTable(self.m_vItemNum)))
    self:reduceRef()

    self.m_tLeft = {}
    WndSell.m_tSellList = {}
end

--@brief　变量m_vItemID和m_vItemNum相应的引用计数-1
function WndSellList:reduceRef()
	if self.m_vItemID == nil or self.m_vItemNum == nil then return end
    self.m_vItemID:release()
    self.m_vItemNum:release()
    self.m_vItemID = nil
    self.m_vItemNum = nil
end

--@brief	返回按钮
function WndSellList:onReturn(element)
	WZLog("WndSellList:onReturn")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self:clearAll()
	WindowManagerAni:createMoveOut(WndBagRole.m_tWndSellList.m_root,0,true,GetElement(WndBagRole.m_root,"conLeft_WndBag",WZUIContainer))
	WindowManagerAni:createMoveOut(WndBagRole.m_tWndSell.m_root,1,true,GetElement(WndBagRole.m_root,"conRight_WndBag",WZUIContainer))
end

--@brief    开始加载
--@note     开始协议信息的加载，显示加载框
function WndSellList:startLoading()
    -- body
    self.m_nLoadingID = MsgBoxManager:showLoadingBox(10)
end

--@brief    加载完成
--@note     加载完成，关闭加载框
function WndSellList:finishedLoading()
    -- body
    local nId = self.m_nLoadingID
    MsgBoxManager:stopLoadingBoxByMsgId(nId)
end

--@brief	出售成功,清空列表
function WndSellList:recycleSucc()
    self:finishedLoading()
    --播放效果音效
    SoundManager:playEffectSound(SoundDefine.E_S_SELL)
	if self.m_root == nil then return end

	self.m_tLeft = {}
    WndSell.m_tSellList = {}
	GetElement(self.m_root,"tableConLeft_WndSellList",WZUITableContainer):cleanTable()
	--for i=1,8 do
	--	GetElement(self.m_root,"conSaleItem"..i,WZUIContainer):removeAllChildrenWithCleanup(true)
	--end
end

--@brief	清空出售列表
function WndSellList:clearAll()
	if self.m_root == nil then return end
	self.m_tLeft = {}
    WndSell.m_tSellList = {}
	GetElement(self.m_root,"tableConLeft_WndSellList",WZUITableContainer):cleanTable()
	--for i=1,8 do
	--	GetElement(self.m_root,"conSaleItem"..i,WZUIContainer):removeAllChildrenWithCleanup(true)
	--end

	WndSell:cleanBag()
	WndSell.m_tData = WndSell:getCurData()
	WndSell:_update(false)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief　刷新出售列表
function WndSellList:_update()
	local getList = {{},{}}

	self.m_tLeft = WndSell.m_tSellList

	--清空回收列表
	--for i=1,8 do
	--	GetElement(self.m_root,"conSaleItem"..i,WZUIContainer):removeAllChildrenWithCleanup(true)
	--end

	--刷新回收列表
	local len = math.min(16,#self.m_tLeft)
	for i=1,len do 
		--local cellElement,tCell = CellGoodItem:createElement()
		--tCell:setCellGoodItem(self.m_tLeft[i],10)
    	--tCell:setItemClickFun(self,self.onClickCallback1)
		--GetElement(self.m_root,"conSaleItem"..i,WZUIContainer):addChild(cellElement)
		if type(self.m_tLeft[i].basicInfo.recycleMess) == "table" and self.m_tLeft[i].basicInfo.recycleMess[1] ~= nil then
			for k=1,#self.m_tLeft[i].basicInfo.recycleMess do
				local added = false
				--之前列表中已有,增加数量
				for j=1,#getList[1] do
					if getList[1][j] == self.m_tLeft[i].basicInfo.recycleMess[k][1] then
						getList[2][j] = getList[2][j] + self.m_tLeft[i].basicInfo.recycleMess[k][2] * self.m_tLeft[i].lastNum
						added = true
					end
				end
				--之前列表中没有,加入列表
				if added == false then
					table.insert(getList[1],self.m_tLeft[i].basicInfo.recycleMess[k][1])
					table.insert(getList[2],self.m_tLeft[i].basicInfo.recycleMess[k][2] * self.m_tLeft[i].lastNum)
				end
			end
		end
		--列出回收物品中的宝石
		local gemList = {"attackStone","defendStone","hpStone","gongmingStone"}
		for k=1,4 do
			if self.m_tLeft[i].extraInfo[gemList[k]] ~= nil and self.m_tLeft[i].extraInfo[gemList[k]] ~= 0 then
				local added = false
				--之前列表中已有,增加数量
				for j=1,#getList[1] do
					if getList[1][j] == self.m_tLeft[i].extraInfo[gemList[k]] then
						getList[2][j] = getList[2][j] + 1
						added = true
					end
				end
				--之前列表中没有,加入列表
				if added == false then
					table.insert(getList[1],self.m_tLeft[i].extraInfo[gemList[k]])
					table.insert(getList[2],1)
				end
			end
		end
	end

	--清空获得列表
	local tableConLeft = WZUITableContainer:luaTo(self.m_root:getChildElement("tableConLeft_WndSellList"))
	tableConLeft:cleanTable()
	tableConLeft:setEnableGlScissor(false)

	--刷新获得列表
	for i=1,#getList[1] do
        local key = "id_"..getList[1][i]
        if GDatatab_item[key] ~= nil then
            local name = GDatatab_item[key].name
            local path = GDatatab_item[key].icon
            local num =  getList[2][i]
            local quality = GDatatab_item[key].quality
            local itemInfo = {name=name,icon=path,lastTime=num,lastNum=num,quality=quality,basicInfo=CopyTable(GDatatab_item[key])}
			local cellElement,tCell = CellGoodItem:createElement()
			tCell:setCellGoodItem(itemInfo,10)
    		tCell:setItemClickFun(self,self.onClickCallback2)
			cellElement:setTag(i-1)
			tableConLeft:setCellElement(cellElement)
        end
	end
	self.m_tGetList = getList
end

--@brief	待回收物品点击回调,取消出售
function WndSellList:onClickCallback1(tCell,tag,tData)
	WZLog("WndSellList:onClickCallback1")
	for i=1,#self.m_tLeft do
		if tData.playerItemId == self.m_tLeft[i].playerItemId then
			--出售列表删除该物品
			table.remove(self.m_tLeft,i)
			break
		end
	end
	--把右边列表里对应物品的状态改为未出售
	for i=1,#WndSell.m_tData do
		if WndSell.m_tData[i].playerItemId == tData.playerItemId then
			WndSell.m_tData[i].sellHook = false
			break
		end
	end
	WndSell.m_tData = WndSell:getCurData()
	WndSell:_update(true)
	WndSellList:_update()
end

--@brief	点击回收获得物品，显示tips
function WndSellList:onClickCallback2(tCell,tag,tData)
	WZLog("WndSellList:onClickCallback2")
   	WndItemInfo:showInfo(tCell.m_root,self.m_root,1,tData, false)
end
-------------------------------------私有方法模块End----------------------------------------

----------------------------------------语言适配Begin---------------------------------------
function WndSellList:_adaptLanguage_tr(  )
	local txtSale = GetElement(self.m_root,"txtSale_WndRecover",WZUILabelTTF)
	txtSale:setDimensions(GlobalMethod:CCSize(130,0))
	txtSale:setScale(0.8)
end

function WndSellList:_adaptLanguage_vn(  )
	GetElement(self.m_root,"txtT_WndSellList",WZUILabelTTF):setScale(0.9)
end

function WndSellList:_adaptLanguage_es(  )
	GetElement(self.m_root,"txtT_WndSellList",WZUILabelTTF):setScale(0.7)
end
---------------------------------------语言适配End-----------------------------------------
