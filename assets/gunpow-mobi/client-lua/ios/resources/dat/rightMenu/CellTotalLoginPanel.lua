--CellTotalLoginPanel.lua
--@brief	CellTotalLoginPanel的UI模块
--@date		2015/05/12
--@author	weidong_wu
--@note		累计陆录活动


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellTotalLoginPanel:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellTotalLoginPanel:onExit(element)
	self:_unInit()
end


--@brief    初始化信息
function CellTotalLoginPanel:setMessage(activityId,rewardId, status, rewardItems, rewardItemsParamCount, rewardCounts, cellItemObj, tips, startTime, endTime)
   self.index = activityId   
   self.rewardId = rewardId 
   self.status = status 
   self.rewardItems = rewardItems 
   self.rewardItemsParamCount=rewardItemsParamCount 
   self.rewardCounts = rewardCounts
   self.m_cellItemObj = cellItemObj
   self.m_tips = tips
   self.m_nStartTime = startTime
   self.m_nEndTime = endTime
end

--@brief    显示窗口
function CellTotalLoginPanel:showWindow()
	local LoginTimes = 0
    if self.status ~= nil then
    	for i=1,#self.status do
    		WZLog("===========================xx=="..self.status[i])
    		if self.status[i] == 1 or self.status[i]==0 then 
    			LoginTimes = LoginTimes+1	
    		end 
    	end
    end
	self:_initStaticTxt(LoginTimes)
    self:_setTabList(  )
    --Modify By Tianxiang_Xu
	-- self.m_currentIndex = LoginTimes-- + self.m_currentIndex   
 --    if self.status[LoginTimes] == 1 then
 --        self.m_currentIndex = LoginTimes + 1
 --    end
 --    --End Modify
	-- if self.m_currentIndex > #self.status and self.status[7] ~= 0 then 
	-- 	self.m_currentIndex = 1
	-- elseif self.m_currentIndex > #self.status and self.status[7] == 0 then 
	-- 	self.m_currentIndex = 7
	-- end 
    self:_UpdateItemReward(self.m_currentIndex)
    AdaptLanguage(self)
end


function CellTotalLoginPanel:Event_Done( element )
    WZLog("********** CellTotalLoginPanel:Event_Done ***********")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	CellTotalLoginPanel.m_current_click = self
	local tag = element:getTag()
	local statusIndex = self.status[tag]
    WZLog("********** CellTotalLoginPanel:Event_Done 111 ***********", statusIndex, self.m_currentIndex, tag)
	if statusIndex == 0 then 
        --背包已满提示
        if CacheCenter:getRemainAmount() <= 0 then
            MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
            return
        end
        
		self.m_nloadingId = MsgBoxManager:showLoadingBox()
		local imgItemkuang_sel = GetElement(self.m_root,"imgItemkuang_sel_"..self.m_currentIndex,WZUIImage)
		imgItemkuang_sel:setFile("ui/strengthen/common_scale9duzaodi.png")
		self.m_currentIndex = tag
		imgItemkuang_sel = GetElement(self.m_root,"imgItemkuang_sel_"..self.m_currentIndex,WZUIImage)
		imgItemkuang_sel:setFile("ui/strengthen/common_scale9duzaodi3.png")
		self:_UpdateItemReward(tag)
		ProtocolProcessorWndActivityOnLine:send_ACTIVITY_ReceiveActivityReward(self.index, self.rewardId[tag] )
		return 
	end

	if self.m_currentIndex == tag then 
		return 
	end 

	local imgItemkuang_sel = GetElement(self.m_root,"imgItemkuang_sel_"..self.m_currentIndex,WZUIImage)
	imgItemkuang_sel:setFile("ui/strengthen/common_scale9duzaodi.png")
	self.m_currentIndex = tag
	imgItemkuang_sel = GetElement(self.m_root,"imgItemkuang_sel_"..self.m_currentIndex,WZUIImage)
	imgItemkuang_sel:setFile("ui/strengthen/common_scale9duzaodi3.png")
	self:_UpdateItemReward(tag)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief 	更新奖励物品
function CellTotalLoginPanel:_UpdateItemReward( index )
	local conFreeList_CellTotalLoginPanel = GetElement(self.m_root,"conFreeList_CellTotalLoginPanel",WZUIFreeListContainer)
	
	if conFreeList_CellTotalLoginPanel:size() > 0 then 
		conFreeList_CellTotalLoginPanel:removeAll()
	end 

    for i=1,#self.rewardId do
        WZLog("rewardId="..i.."="..self.rewardId[i])
    end
    for i=1,#self.rewardItemsParamCount do
        WZLog("rewardItemsParamCount="..i.."="..self.rewardItemsParamCount[i])
    end
    local ItemIdx = 1
    local index = 1
    for i=1,#self.rewardId do
        if not (self.rewardId[i] == -1) then 
            local ItemTab = nil 
            if ItemIdx > #self.m_tRewardList.m_tDoingList then 
                ItemTab = self.m_tRewardList.m_tDoneList[index]
                index = index + 1
            else 
                ItemTab = self.m_tRewardList.m_tDoingList[index]
                if ItemIdx == #self.m_tRewardList.m_tDoingList then 
                    index = 1 
                else 
                    index = index + 1
                end 
            end
            local cellElement,newLuaObj = CellGradePanelItem:createElement()
            cellElement = WZUIContainer:luaTo(cellElement)
            WZLog("****** SSSSSSSSSS *********",ItemTab.rewardId, self.rewardId[i], i)
            local sDays = tostring(ItemTab.rewardId + 1)
            newLuaObj:setMessage(ItemIdx,ItemTab.rewardId,ItemTab.m_tData,sDays,ItemTab.status,self.index,self.m_cellItemObj)
            newLuaObj:setUIType(0)
            cellElement:setTag(ItemIdx-1)
            cellElement:setContentSize(GlobalMethod:CCSize(486,138))
            cellElement:setRelativeSize(GlobalMethod:CCSize(1,138/344))
            newLuaObj:setFunc(self.sortItemByIndex,CellTotalLoginPanel)
            conFreeList_CellTotalLoginPanel:pushBack(cellElement)
            ItemIdx = ItemIdx + 1
        end 
    end

	conFreeList_CellTotalLoginPanel:update()
	conFreeList_CellTotalLoginPanel:getMoveElement():setPositionY(conFreeList_CellTotalLoginPanel:getMinPosition().y)

end


--@brief    其它Item点击回调
function CellTotalLoginPanel:onOthersClick(luaTable,tag,tData)
    if tData == nil then
       return
    end
    local tagindex = tag+1
    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(luaTable.m_root,self.m_root,1,tData,false)
end

--@brief    奖励获取成功回调  
function CellTotalLoginPanel:_GetRewardOk(  )
    CellTotalLoginPanel.m_current_click.status[CellTotalLoginPanel.m_current_click.m_currentIndex] = 1
    local imgItemkuang_sel = GetElement(self.m_root,"imgItemkuang_sel_"..CellTotalLoginPanel.m_current_click.m_currentIndex,WZUIImage)
    imgItemkuang_sel:setFile("ui/strengthen/common_scale9duzaodi.png")
    local ImageItemIcon_Obj = GetElement(self.m_root,"ImageItemIcon_Obj_"..CellTotalLoginPanel.m_current_click.m_currentIndex,WZUIImage)
    ImageItemIcon_Obj:setGrayRender(true)

    local ImageItemName_Obj = GetElement(self.m_root,"ImageItemName_Obj_"..CellTotalLoginPanel.m_current_click.m_currentIndex,WZUIImage)
	ImageItemName_Obj:setFile("ui/common/commom_icon_ylq.png")
	ImageItemName_Obj:setRotation(28)
	ImageItemName_Obj:setAnchorPoint(GlobalMethod:ccp(0.5,0))
	ImageItemName_Obj:setRelativePosition(GlobalMethod:ccp(0.35,0))

	local armBox_CellTotalLoginPanel = GetElement(self.m_root,"armBox"..CellTotalLoginPanel.m_current_click.m_currentIndex.."_CellTotalLoginPanel",WZArmature)
	armBox_CellTotalLoginPanel:setVisible(false)

	local times = 0

	for i=1,#CellTotalLoginPanel.m_current_click.status do
		if CellTotalLoginPanel.m_current_click.status[i] == 1 or CellTotalLoginPanel.m_current_click.status[i] == 0 then 
			times = times + 1 
		end 
	end

	--WZLog("==================times===="..times)

	local txtMsgInfo_num_CellTotalLoginPanel = GetElement(CellTotalLoginPanel.m_current_click.m_root,"txtMsgInfo_num_CellTotalLoginPanel",WZUILabelTTF)
	if txtMsgInfo_num_CellTotalLoginPanel ~= nil  then 
		local idx = times
		if idx < 8 then 
			txtMsgInfo_num_CellTotalLoginPanel:setText(string.format("%d",idx))
			local pos_index = CellTotalLoginPanel.m_current_click.m_currentIndex+1
			if pos_index > 7 then 
				pos_index = 1 
			end 
			if CellTotalLoginPanel.m_current_click.status[pos_index] == 0 then 
			else 
				local imgItemkuang_sel = GetElement(CellTotalLoginPanel.m_current_click.m_root,"imgItemkuang_sel_"..pos_index,WZUIImage)
				imgItemkuang_sel:setFile("ui/strengthen/common_scale9duzaodi3.png")
			end 
			CellTotalLoginPanel.m_current_click.m_currentIndex = pos_index
			CellTotalLoginPanel.m_current_click:_UpdateItemReward(CellTotalLoginPanel.m_current_click.m_currentIndex)
		end 
	end
end


function CellTotalLoginPanel:_initStaticTxt( LoginTimes )
	local m_tTxtInfo = {LocalStrings.ACTIVITY_CUMULATIVE_LOGIN,
						LocalStrings.ACTIVITY_CUMULATIVE_LOGIN_CP}
	for i=1,2 do
		local txtMsgInfo_CellTotalLoginPanel = GetElement(self.m_root,"txtMsgInfo_"..i.."_CellTotalLoginPanel",WZUILabelTTF)
		if txtMsgInfo_CellTotalLoginPanel ~= nil then 
			txtMsgInfo_CellTotalLoginPanel:setText(m_tTxtInfo[i])
		end 
	end

	local txtMsgInfo_num_CellTotalLoginPanel = GetElement(self.m_root,"txtMsgInfo_num_CellTotalLoginPanel",WZUILabelTTF)
	if txtMsgInfo_num_CellTotalLoginPanel ~= nil  then 
		txtMsgInfo_num_CellTotalLoginPanel:setText(string.format("%d",LoginTimes))
	end 

    --活动时间
    local txtActivityTime = GetElement(self.m_root, "txtActivityTime_CellTotalLoginPanel", WZUILabelTTF)
    txtActivityTime:setText(LocalStrings.ACTIVE_TIME .. ":")
    --具体日期
    local txtTimeValue = GetElement(self.m_root, "txtTimeValue_CellTotalLoginPanel", WZUILabelTTF)
    local DayStartTab = os.date("*t",self.m_nStartTime)
    local DayEndTab = os.date("*t",self.m_nEndTime)
    local sTimeValue = string.format(LocalStrings.ACTIVITYTIME_FORMAT, DayStartTab.month, DayStartTab.day, DayStartTab.hour, DayStartTab.min, DayEndTab.month, DayEndTab.day, DayEndTab.hour, DayEndTab.min)
    txtTimeValue:setText(sTimeValue)
end


function CellTotalLoginPanel:_setTabList(  )
    self.m_tRewardList = {}
    self.m_tRewardList.m_tDoingList = {}
    self.m_tRewardList.m_tDoneList = {}
    local ItemCount = 1
    local DoneIdx = 1
    local DoingIdx = 1
    local itemIndex = 1
    for i=1,#self.rewardId do
        if not  (self.rewardId[i] == -1) then 
        local Items
        if self.status[i]==1 then 
            Items = self.m_tRewardList.m_tDoneList
            Items[DoneIdx] = {}
            Items[DoneIdx].rewardId = self.rewardId[i]
            local tData = {}
            local itemCount = self.rewardCounts[i]
            for i=1,itemCount do
                local t_item = {id=self.rewardItems[itemIndex],num=self.rewardItemsParamCount[itemIndex]}
                table.insert(tData,t_item)
                itemIndex = itemIndex + 1
            end
            Items[DoneIdx].m_tData = tData 
            Items[DoneIdx].tip=self.m_tips[i]
            Items[DoneIdx].status = self.status[i]
            DoneIdx = DoneIdx +1
        else 
            Items = self.m_tRewardList.m_tDoingList 
            Items[DoingIdx] = {}
            Items[DoingIdx].rewardId = self.rewardId[i]
            local tData = {}
            local itemCount = self.rewardCounts[i]
            for i=1,itemCount do
                local t_item = {id=self.rewardItems[itemIndex],num=self.rewardItemsParamCount[itemIndex]}
                table.insert(tData,t_item)
                itemIndex = itemIndex + 1
            end
            Items[DoingIdx].m_tData = tData
            Items[DoingIdx].tip=self.m_tips[i]
            Items[DoingIdx].status = self.status[i]
            DoingIdx = DoingIdx +1
        end 
        end 
    end
end

--@brief    
function CellTotalLoginPanel:sortItemByIndex( nIndex )
    WZLog("CellLoginActivityPanel:removeItemByIndex index="..nIndex)
    local size =  #CellTotalLoginPanel.m_current.m_tRewardList.m_tDoingList
    local removePos = 0
    for i=1,size do
        if nIndex == CellTotalLoginPanel.m_current.m_tRewardList.m_tDoingList[i].rewardId then 
            local len = #CellTotalLoginPanel.m_current.m_tRewardList.m_tDoneList
            CellTotalLoginPanel.m_current.m_tRewardList.m_tDoneList[len+1] = {}
            CellTotalLoginPanel.m_current.m_tRewardList.m_tDoneList[len+1].rewardId = CellTotalLoginPanel.m_current.m_tRewardList.m_tDoingList[i].rewardId
            CellTotalLoginPanel.m_current.m_tRewardList.m_tDoneList[len+1].m_tData = CellTotalLoginPanel.m_current.m_tRewardList.m_tDoingList[i].m_tData
            CellTotalLoginPanel.m_current.m_tRewardList.m_tDoneList[len+1].status=1
            CellTotalLoginPanel.m_current.m_tRewardList.m_tDoneList[len+1].tip=CellTotalLoginPanel.m_current.m_tRewardList.m_tDoingList[i].tip
            removePos = i
        end 
    end
    table.remove(CellTotalLoginPanel.m_current.m_tRewardList.m_tDoingList,removePos)
    CellTotalLoginPanel.m_current:_UpdateItemReward()
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配模块Begin----------------------------------------
function CellTotalLoginPanel:_adaptLanguage_en()
    local txtMsgInfo = GetElement(self.m_root,"txtMsgInfo_1_CellTotalLoginPanel",WZUILabelTTF)
    local txtWidth = txtMsgInfo:getLabelContentSize().width + 45

    local txtMsgInfo_num = GetElement(self.m_root,"txtMsgInfo_num_CellTotalLoginPanel",WZUILabelTTF)
    txtMsgInfo_num:setRelativePosition(GlobalMethod:ccp(0.539583,0.5))

    local txtMsgInfo_2 = GetElement(self.m_root,"txtMsgInfo_2_CellTotalLoginPanel",WZUILabelTTF)
    txtMsgInfo_2:setRelativePosition(GlobalMethod:ccp(0.593749,0.5))

    local txtMsgInfo_num = GetElement(self.m_root,"txtMsgInfo_num_CellTotalLoginPanel",WZUILabelTTF)
    txtMsgInfo_num:setRelativePosition(GlobalMethod:ccp(0.53,0.5))
end

function CellTotalLoginPanel:_adaptLanguage_pt(  )
    local txtMsgInfo = GetElement(self.m_root,"txtMsgInfo_1_CellTotalLoginPanel",WZUILabelTTF)
    local txtWidth = txtMsgInfo:getLabelContentSize().width + 45
    --WZLog("CellTotalLoginPanel:_adaptLanguage_pt")
    local txtMsgInfo_num = GetElement(self.m_root,"txtMsgInfo_num_CellTotalLoginPanel",WZUILabelTTF)
    txtMsgInfo_num:setRelativePosition(GlobalMethod:ccp(0.65,0.5))

    local txtMsgInfo_2 = GetElement(self.m_root,"txtMsgInfo_2_CellTotalLoginPanel",WZUILabelTTF)
    txtMsgInfo_2:setRelativePosition(GlobalMethod:ccp(0.68,0.5))

    GetElement(self.m_root,"txtTimeValue_CellTotalLoginPanel",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.43,0.5))
end

function CellTotalLoginPanel:_adaptLanguage_vn(  )
    GetElement(self.m_root,"txtTimeValue_CellTotalLoginPanel",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.5,0.5))
    local txtMsgInfo_num = GetElement(self.m_root,"txtMsgInfo_num_CellTotalLoginPanel",WZUILabelTTF)
    txtMsgInfo_num:setRelativePosition(GlobalMethod:ccp(0.5,0.5))

    local txtMsgInfo_2 = GetElement(self.m_root,"txtMsgInfo_2_CellTotalLoginPanel",WZUILabelTTF)
    txtMsgInfo_2:setRelativePosition(GlobalMethod:ccp(0.55,0.5))
end

function CellTotalLoginPanel:_adaptLanguage_es(  )
    local txtMsgInfo_2 = GetElement(self.m_root,"txtMsgInfo_2_CellTotalLoginPanel",WZUILabelTTF)
    txtMsgInfo_2:setRelativePosition(GlobalMethod:ccp(0.56,0.5))

    local txtMsgInfo_num = GetElement(self.m_root,"txtMsgInfo_num_CellTotalLoginPanel",WZUILabelTTF)
    txtMsgInfo_num:setRelativePosition(GlobalMethod:ccp(0.53,0.5))
end

function CellTotalLoginPanel:_adaptLanguage_tr(  )
    local txtMsgInfo_num = GetElement(self.m_root,"txtMsgInfo_num_CellTotalLoginPanel",WZUILabelTTF)
    txtMsgInfo_num:setRelativePosition(GlobalMethod:ccp(0.56,0.5))

    local txtMsgInfo_2 = GetElement(self.m_root,"txtMsgInfo_2_CellTotalLoginPanel",WZUILabelTTF)
    txtMsgInfo_2:setRelativePosition(GlobalMethod:ccp(0.6,0.5))
end
-------------------------------------私有方法模块End----------------------------------------
