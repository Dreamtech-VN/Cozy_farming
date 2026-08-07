--WndChooseReward.lua
--@brief	WndChooseReward的UI模块
--@date		2021/05/14
--@author	hyc
--@note		自选礼包选择奖励


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndChooseReward:onEnter(element)
	self.m_root = element
	ProtocolProcessorRecycling:regAll()

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndChooseReward:onExit(element)
	self:_unInit()
end

--@关闭
function WndChooseReward:onClickClose(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	if self.m_root == nil then
		return
	end
	WindowManager:removeWindow(self.m_root, self, true)
end

--@选择奖励物品后开启自选礼包
function WndChooseReward:onOpenReward(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nWinType == 1 then 
	    local sAtt = self:_checkGoodsEnough()
	    if sAtt then
	        MsgBoxManager:showTipBox(sAtt .. " " .. LocalStrings.NOT_ENABLE)
	        return
	    end
	    if self.m_data.tCell and self.m_data.func then 
	    	  self.m_data.func(self.m_data.tCell, self.m_nNum)
	    end
	else
		WZLog("礼包数据",self.m_data.playerItemId,self.m_chooseData.id)
		ProtocolProcessorRecycling:send_PLAYERITEM_OpenGift(self.m_data.playerItemId, self.m_nNum, self.m_chooseData.id)
	end
	self:onClickClose()
end

function WndChooseReward:onUpdateUi( )
	local tData = self.m_data
	local tabAll = GetElement(self.m_root,"tabAllReward_WndChooseReward",WZUIFreeListContainer)
	tabAll:removeAll()
	local sex = CacheCenter:getPlayerInfo().sex
	local rewardList = {}
	local rewardNums = {}
	for k,v in pairs(GDatatab_gifts) do
		if v.item_id == self.m_data.id then
			if sex == 0 then -- 男
				table.insert(rewardList,v.man_item_id)
			else
				table.insert(rewardList,v.woman_item_id)
			end
			table.insert(rewardNums,v.count)
		end
	end
	local n_index = 1
	WZLog("自选礼包包含奖励:",#rewardList,Serialize(rewardList))
	for i = 1,#rewardList do
		local key = "id_".. rewardList[i]
		local tabItem = GDatatab_item[key]
		local itemInfo = {id = tabItem.id, name=tabItem.name,icon=tabItem.icon,lastTime=rewardNums[i],quality=tabItem.quality,basicInfo=CopyTable(tabItem)}
		local celElement,tCell = CellGoodItem:createElement()
		if celElement and tCell then
			tCell:setCellGoodItem(itemInfo, 17)
			celElement:setTag(i-1)
			tCell:setItemClickFun(self,self.onItemClick)
			table.insert(self.m_tabList,tCell)
			if n_index == 1 then
				self:onItemClick(tCell,i-1,itemInfo)
			end
			tabAll:pushBack(WZUIContainer:luaTo(celElement))
		end
	    local miny = tabAll:getMaxPosition().x
		tabAll:getMoveElement():setPositionX(miny)
		n_index = n_index + 1
	end

	GetElement(self.m_root,"useNum_WndChooseReward",WZUILabelTTF):setText(self.m_nNum)
	GetElement(self.m_root,"txtExplanation_WndChooseReward",WZUILabelTTF):setText(string.format(LocalStrings.PETNOTUPONE3, self.m_nMaxNum))
end

--@brief	点击物品选中
function WndChooseReward:onItemClick(tCell,tag,tData)
    if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
   	-- WndItemInfo:showInfo(tCell.m_root,self.m_root,1,tData,false)
   	for i = 1,#self.m_tabList do
   		if i == tag + 1 then
   			self.m_tabList[i]:showSelectedIcon(2)
   		else 
   			self.m_tabList[i]:removeGouIcon()
   		end
   	end
   	WZLog("选中物品的数据",Serialize(tData))
   	self:updateChooseReward(tData)
end

--@brief	更新选中的奖励
function WndChooseReward:updateChooseReward(tData)
	-- body
	self.m_chooseData = tData
    local txtColor = {GlobalMethod:ccc3(99,255,95), GlobalMethod:ccc3(93,222,254), GlobalMethod:ccc3(198,130,255), GlobalMethod:ccc3(233,166,62)}
    local color = txtColor[tData.quality]

	WZLog("选中的奖励",Serialize(tData))
	local conNode = GetElement(self.m_root,"conChooseReward_WndChooseReward",conChooseReward_WndChooseReward)
	conNode:removeAllChildrenWithCleanup(true)
	local itemInfo = {id = tData.id, name = tData.name, icon=tData.icon, lastTime= tData.lastTime, quality = tData.quality, basicInfo = CopyTable(tData)}
	local celElement,tCell = CellGoodItem:createElement()
	if celElement and tCell then
		tCell:setCellGoodLocalId(tData.id, tData.lastTime, 17)
		celElement:setTag(1)
		conNode:addChild(celElement)

	end
	local name = GetElement(self.m_root,"name",WZUILabelTTF)
	name:setText(tData.name)
	name:setColor(color or GlobalMethod:ccc3(233,166,62))

	GetElement(self.m_root,"desc",WZUILabelTTF):setText(tData.basicInfo.desc)

	local desc = GetElement(self.m_root,"desc",WZUILabelTTF)
	desc:setFontSize(16)
	if tData.basicInfo.main_type == 45 and tData.basicInfo.sub_type == 1 then
		desc:setRelativePosition(GlobalMethod:ccp(0.5,0.44))
	else
		desc:setRelativePosition(GlobalMethod:ccp(0.25,0.25))
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	减少10个
function WndChooseReward:onMutiReduce(element)
	WZLog("WndChooseReward:onMutiReduce")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nNum > 10 then
		self.m_nNum = self.m_nNum - 10
	else
		self.m_nNum = 1
		MsgBoxManager:showTipBox(LocalStrings.CHESTMINNUM)
	end
	GetElement(self.m_root,"useNum_WndChooseReward",WZUILabelTTF):setText(self.m_nNum)
end

--@brief	减少1个
function WndChooseReward:onReduce(element)
	WZLog("WndChooseReward:onReduce")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nNum - 1 >= 1 then
		self.m_nNum = self.m_nNum - 1
	else
		MsgBoxManager:showTipBox(LocalStrings.CHESTMINNUM)
	end
	GetElement(self.m_root,"useNum_WndChooseReward",WZUILabelTTF):setText(self.m_nNum)
end

--@brief	增加10个
function WndChooseReward:onMutiAdd(element)
	WZLog("WndChooseReward:onMutiAdd")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if self.m_nNum < self.m_nMaxNum - 10 then
		self.m_nNum = self.m_nNum + 10
	else
		self.m_nNum = self.m_nMaxNum
		MsgBoxManager:showTipBox(LocalStrings.CHESTMAXNUM)
	end
	if self.m_nNum == 0 then self.m_nNum = 1 end
	GetElement(self.m_root,"useNum_WndChooseReward",WZUILabelTTF):setText(self.m_nNum)
end

--@brief	增加1个
function WndChooseReward:onAdd(element)
	WZLog("WndChooseReward:onAdd")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	
	if self.m_nNum + 1 <= self.m_nMaxNum then
		self.m_nNum = self.m_nNum + 1
	else
		MsgBoxManager:showTipBox(LocalStrings.CHESTMAXNUM)
	end
	if self.m_nNum == 0 then self.m_nNum = 1 end
	GetElement(self.m_root,"useNum_WndChooseReward",WZUILabelTTF):setText(self.m_nNum)
end

--@brief 	显示兑换窗口
function WndChooseReward:onUpdateUiExchange( )
	local txtTitle1 = GetElement(self.m_root, "txtTitle1_WndChooseReward", WZUILabelTTF)
	local txtTitle2 = GetElement(self.m_root, "txtTitle2_WndChooseReward", WZUILabelTTF)
	txtTitle1:setTextKey("")
	txtTitle2:setTextKey("")
	txtTitle1:setText(LocalStrings.MARRY_END[9])
	txtTitle2:setText(LocalStrings.MARRY_END[10])

	local tData = self.m_data
	local tabAll = GetElement(self.m_root,"tabAllReward_WndChooseReward",WZUIFreeListContainer)
	tabAll:removeAll()
	local sex = CacheCenter:getPlayerInfo().sex
	local rewardList = {}
	local rewardNum = {}

	local n_index = 1
	for i = 1,#tData.cost do
		local key = "id_".. tData.cost[i].id
		local tabItem = GDatatab_item[key]
		local itemInfo = {id = tabItem.id, name=tabItem.name,icon=tabItem.icon,lastTime=tData.cost[i].num,quality=tabItem.quality,basicInfo=CopyTable(tabItem)}
		local celElement,tCell = CellGoodItem:createElement()
		if celElement and tCell then
			tCell:setCellGoodItem(itemInfo, 17)
			celElement:setTag(i-1)
			tCell:setItemClickFun(self,self.onOthersClick)
			tabAll:pushBack(WZUIContainer:luaTo(celElement))

			--数量
         local nTempNum = tData.cost[i].num 
         if nTempNum == -1 then
             nTempNum = 1 
         end
         
        local nLastNum = CacheCenter:getPlayerItemCountById(tData.cost[i].id)
        local itemInfo = GDatatab_item["id_"..tData.cost[i].id]
        if itemInfo.main_type == 10 then
            nLastNum = CacheCenter:getPetCountByItemId(tData.cost[i].id)
        elseif itemInfo.main_type == 37 then
            nLastNum = 0
            local tSkinEquipmentData = CellExchangePanel.m_current.m_tSkinEquipmentData
            for j=1,#tSkinEquipmentData do
                if tSkinEquipmentData[j].id == tData.cost[i].id then
                    nLastNum = nLastNum + 1
                end
            end
        end
         if nLastNum == -1 then
             nLastNum = 1
         else
             if tabItem.main_type == 5 then
                 if nLastNum > 0 then
                     nLastNum = 0 
                 end
             end
         end

         tCell:_setItemCountText(nLastNum, nTempNum, 16)
		end
	    local miny = tabAll:getMaxPosition().x
		tabAll:getMoveElement():setPositionX(miny)
		n_index = n_index + 1
	end

	self:updateExchangeReward()
	GetElement(self.m_root,"useNum_WndChooseReward",WZUILabelTTF):setText(self.m_nNum)
	GetElement(self.m_root,"txtExplanation_WndChooseReward",WZUILabelTTF):setText(string.format(LocalStrings.PETNOTUPONE3, self.m_nMaxNum))
end

--@brief	显示兑换的奖励
function WndChooseReward:updateExchangeReward()
	-- body
	local tData = GDatatab_item["id_" .. self.m_data.reward[1].id]
  
	local conNode = GetElement(self.m_root,"conChooseReward_WndChooseReward",conChooseReward_WndChooseReward)
	conNode:removeAllChildrenWithCleanup(true)
	local itemInfo = {id = tData.id, name = tData.name, icon=tData.icon, lastTime= self.m_data.reward[1].num, quality = tData.quality, basicInfo = CopyTable(tData)}
	local celElement,tCell = CellGoodItem:createElement()
	if celElement and tCell then
		tCell:setCellGoodItem(itemInfo,17)
		celElement:setTag(1)
		conNode:addChild(celElement)

	end
	local name = GetElement(self.m_root,"name",WZUILabelTTF)
	name:setText(tData.name)
	if tData.quality == 1 then
		name:setColor(GlobalMethod:ccc3(99,255,95))
	elseif tData.quality == 2 then
		name:setColor(GlobalMethod:ccc3(93,222,254))
	elseif tData.quality == 3 then
		name:setColor(GlobalMethod:ccc3(198,130,255))
	else
		name:setColor(GlobalMethod:ccc3(233,166,62))
	end
	GetElement(self.m_root,"desc",WZUILabelTTF):setText(tData.desc)

	local desc = GetElement(self.m_root,"desc",WZUILabelTTF)
	desc:setFontSize(18)
	if tData.main_type == 45 and tData.sub_type == 1 then
		desc:setRelativePosition(GlobalMethod:ccp(0.6,0.44))
	else
		desc:setRelativePosition(GlobalMethod:ccp(0.25,0.25))
	end
end

--@brief    点击Item时回调tips
function WndChooseReward:onOthersClick(luaTable,tag,tData)
    if tData == nil then
       return
    end

    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(luaTable.m_root,self.m_root,1,tData,false)
end

--@brief    检测消耗道具是否不足
function WndChooseReward:_checkGoodsEnough()
    -- body
    local sAtt = nil 
    local tConsumeData = self.m_data.cost
    if tConsumeData then
        for i = 1, #tConsumeData do
            local nLastNum = CacheCenter:getPlayerItemCountById(tConsumeData[i].id)
            local itemInfo = GDatatab_item["id_"..tConsumeData[i].id]
            if itemInfo.main_type == 10 then
                nLastNum = CacheCenter:getPetCountByItemId(tConsumeData[i].id)
            elseif itemInfo.main_type == 37 then
                nLastNum = 0
                local tSkinEquipmentData = CellExchangePanel.m_current.m_tSkinEquipmentData
                for j=1,#tSkinEquipmentData do
                    if tSkinEquipmentData[j].id == tConsumeData[i].id then
                        nLastNum = nLastNum + 1
                    end
                end
            end
            local key = "id_" .. tConsumeData[i].id
            if GDatatab_item[key].main_type == 5 then 
                if nLastNum ~= tConsumeData[i].num then
                    sAtt = GDatatab_item[key].name
                    break 
                end
            else
                if nLastNum < tConsumeData[i].num * self.m_nNum then
                    sAtt = GDatatab_item[key].name
                    break 
                end
            end
        end
    end

    return sAtt
end
-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配begin----------------------------------------
function WndChooseReward:_adaptLanguage_vn()
	local desc = GetElement(self.m_root,"desc",WZUILabelTTF)
	desc:setDimensions(GlobalMethod:CCSize(480,0))
	desc:setAlignment(kCCTextAlignmentLeft)
end
-------------------------------------语言适配end----------------------------------------