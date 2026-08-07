--WndEquipRewardData.lua
--@brief	WndEquipReward的数据模块
--@date		2017/11/09
--@author	qixiang
--@note		显示装备召唤奖励

WndEquipReward = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndEquipReward:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nType = 0 					--0：装备召唤奖励；1：商城抽奖奖励
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndEquipReward:_unInit()
	self.m_root = nil
	self.m_nType = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndEquipReward:createElement()
	if WndEquipReward.m_root ~= nil then
		WindowManager:removeWindow(WndEquipReward.m_root, WndEquipReward, true)
	end
	local element = WZUISystem:getInstance():createElement("WndEquipReward")
	assert(element, "WndEquipReward create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
--@param 	nType : 0:装备召唤奖励；1：商城抽奖奖励
function WndEquipReward:showInterface(nType)
	-- body
	local equipElement = WndEquipReward:createElement()
	if equipElement then 
		self.m_nType = nType or 0
		WindowManager:addWindow(equipElement,WndEquipReward,true,nil,nil,true)
	end
end

function WndEquipReward:setRewardData(tRewardData,tRewardItems,nCount)
	-- body
	WZLog("WndEquipReward:setRewardData")
	if self.m_root == nil then
	    return 
	end
	if tRewardData ~= nil then
		local tabRewardList = GetElement(self.m_root,"tabRewardList_WndEquipReward",WZUITableContainer)
		if self.m_nType == 0 then 
			tabRewardList:setVisible(true)
			GetElement(self.m_root, "conForLottery_WndEquipReward", WZUIContainer):setVisible(false)
			tabRewardList:cleanTable()
			for i,v in ipairs(tRewardData.targetTimes) do
				local cellEquipRewardItem = CreateElement("CellEquipRewardItem")
				cellEquipRewardItem:setTag(i-1)
				cellEquipRewardItem:setVisible(true)
				local btnGitReward = GetElement(cellEquipRewardItem,"btnGitReward_CellEquipRewardItem",WZUIButton)
				local imgHasGive = GetElement(cellEquipRewardItem,"imgHasGive_CellEquipRewardItem",WZUIImage)
				local txtRewardCount = GetElement(cellEquipRewardItem,"txtRewardCount_CellEquipRewardItem",WZUIFreeTextBox)
				btnGitReward:setTag(tRewardData.targetTimes[i])
				if tRewardData.status[i] == 1 then
					btnGitReward:setVisible(false)
					imgHasGive:setVisible(true)
				    txtRewardCount:setShowText(LocalStrings.GIVE_MOVE4)
				elseif tRewardData.status[i] == -1 then
					btnGitReward:setTouchEnable(false)

					local temp = string.format(LocalStrings.GIVE_MOVE2,v-nCount)
				    txtRewardCount:setShowText(temp)
				elseif tRewardData.status[i] == 0 then
					txtRewardCount:setShowText(LocalStrings.GIVE_MOVE3)
				end
				

				local conItem = GetElement(cellEquipRewardItem,"conItem_CellEquipRewardItem",WZUIContainer)
				local itemElement = self:_createCellGoodItem(i, tRewardItems[i])
				conItem:addChild(itemElement)

				tabRewardList:setCellElement(cellEquipRewardItem)

				if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "tr" or ProjConfig.LANGUAGE == "vn" then
					txtRewardCount:setScale(0.7)
					txtRewardCount:setMaxWidth(290)
					GetElement(cellEquipRewardItem,"txtGitReward1_CellEquipRewardItem",WZUILabelTTF):setScale(0.7)
					GetElement(cellEquipRewardItem,"txtGitReward2_CellEquipRewardItem",WZUILabelTTF):setScale(0.7)
					GetElement(cellEquipRewardItem,"txtGitReward3_CellEquipRewardItem",WZUILabelTTF):setScale(0.7)
				end
			end
		elseif self.m_nType == 1 then 
			tabRewardList:setVisible(false)
			GetElement(self.m_root, "conForLottery_WndEquipReward", WZUIContainer):setVisible(true)
			tabRewardList = GetElement(self.m_root,"tabRewardLottery_WndEquipReward", WZUITableContainer)

			tabRewardList:cleanTable()
			for i, v in ipairs(tRewardData) do
				local cellEquipRewardItem = CreateElement("CellEquipRewardItem")
				cellEquipRewardItem:setTag(i-1)
				cellEquipRewardItem:setVisible(true)
				local btnGitReward = GetElement(cellEquipRewardItem,"btnGitReward_CellEquipRewardItem",WZUIButton)
				local imgHasGive = GetElement(cellEquipRewardItem,"imgHasGive_CellEquipRewardItem",WZUIImage)
				local txtRewardCount = GetElement(cellEquipRewardItem,"txtRewardCount_CellEquipRewardItem",WZUIFreeTextBox)
				btnGitReward:setTag(v.extId)
				if v.status == 2 then
					btnGitReward:setVisible(false)
					imgHasGive:setVisible(true)
				    txtRewardCount:setShowText(LocalStrings.GIVE_MOVE4)
				elseif v.status == 0 then
					btnGitReward:setTouchEnable(false)

					local temp = string.format(LocalStrings.LUCKY_GIFT_TIMES2, v.targetTimes - nCount)
				    txtRewardCount:setShowText(temp)
				elseif v.status == 1 then
					txtRewardCount:setShowText(LocalStrings.GIVE_MOVE3)
				end
				

				local conItem = GetElement(cellEquipRewardItem,"conItem_CellEquipRewardItem",WZUIContainer)
				local itemElement = self:_createCellGoodItem(i, {v.rewardId, v.rewardNum})

				conItem:addChild(itemElement)

				tabRewardList:setCellElement(cellEquipRewardItem)

				if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "tr" or ProjConfig.LANGUAGE == "vn" then
					txtRewardCount:setScale(0.7)
					txtRewardCount:setMaxWidth(290)
					GetElement(cellEquipRewardItem,"txtGitReward1_CellEquipRewardItem",WZUILabelTTF):setScale(0.7)
					GetElement(cellEquipRewardItem,"txtGitReward2_CellEquipRewardItem",WZUILabelTTF):setScale(0.7)
					GetElement(cellEquipRewardItem,"txtGitReward3_CellEquipRewardItem",WZUILabelTTF):setScale(0.7)
				end
			end
		end
		
	end
end

--@brief    创建一个物品格子
--@param    nIndex, 序号
--@param    nItemId, 物品id
function WndEquipReward:_createCellGoodItem(nIndex, nItemId)
    local eItem, tItem = CellGoodItem:createElement()
    eItem:setTag(nIndex)
    tItem:setItemClickFun(self, self.onClickListItem)
    eItem:setScale(0.6)
    local tData = nil
    if type(nItemId) == "table" then
        local itemId = nItemId[1]
        local itemNum = nItemId[2]
        tData = {
            id = itemId,
            lastNum = itemNum,
            lastTime = 1,
            isUse = false,
            data = "",
            playerItemId = -1,
            basicInfo = GetItemLocalData(itemId)
        }
    else
        tData = {
            id = nItemId,
            lastNum = 0,
            lastTime = 1,
            isUse = false,
            data = "",
            playerItemId = -1,
            basicInfo = GetItemLocalData(nItemId)
        }
    end
    
    tItem:setCellGoodItem(tData,4)
    return eItem, tItem
end

--@brief	点击物品后的回调
--@param	tItem:物品节点绑定的lua表
--@param    nTag:序号
--@param    tData:物品数据表
function WndEquipReward:onClickListItem(tItem, nTag, tData)
    WZLog("WndEquipReward:onClickListItem ",nTag)
    WndItemInfo:onCloseClick()
    local offset = GlobalMethod:ccp(0,0)
    if nTag >= 4 then
		if tData.basicInfo.main_type == 4 or tData.basicInfo.main_type == 9 then
        	offset = GlobalMethod:ccp(100,0)
		end
    end
    WndItemInfo:showInfo(tItem.m_root,self.m_root,1,tData,false,offset)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
