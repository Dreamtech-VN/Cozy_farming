--CellNewTotalLogin.lua
--@brief	CellTotalLoginPanel的UI模块
--@date		2015/05/12
--@author	weidong_wu
--@note		累计陆录活动


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellNewTotalLogin:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellNewTotalLogin:onExit(element)
	self:_unInit()
end



--@brief    显示窗口
function CellNewTotalLogin:showWindow()
	local LoginTimes = self.count
	self:_initStaticTxt(LoginTimes)
    self:_setTabList(  )

    self:_UpdateItemReward(self.m_currentIndex)
end


function CellNewTotalLogin:Event_Done( element )
    WZLog("********** CellNewTotalLogin:Event_Done ***********")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	CellNewTotalLogin.m_current_click = self
	local tag = element:getTag()
	local statusIndex = self.status[tag]
    WZLog("********** CellNewTotalLogin:Event_Done 111 ***********", statusIndex, self.m_currentIndex, tag)
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
function CellNewTotalLogin:_UpdateItemReward( index )
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
				--WZLog("路径1",Serialize(ItemTab))
                index = index + 1
            else 
                ItemTab = self.m_tRewardList.m_tDoingList[index]
				--WZLog("路径2",Serialize(ItemTab))
                if ItemIdx == #self.m_tRewardList.m_tDoingList then 
                    index = 1 
                else 
                    index = index + 1
                end 
            end
            local cellElement,newLuaObj = CellGradePanelItem:createElement()
            cellElement = WZUIContainer:luaTo(cellElement)
            WZLog("****** SSSSSSSSSS *********",ItemTab.rewardId, self.rewardId[i], i)
            --local sDays = tostring(ItemTab.rewardId + 1)
			local sDays = ItemTab.target
			--WZLog("ksljekkkkk",Serialize(ItemTab))
            newLuaObj:setMessage(ItemIdx,ItemTab.rewardId,ItemTab.m_tData,sDays,ItemTab.status,self.index,self.m_cellItemObj)
            newLuaObj:setUIType(2)
            cellElement:setTag(ItemIdx-1)
            cellElement:setContentSize(GlobalMethod:CCSize(486,138))
            cellElement:setRelativeSize(GlobalMethod:CCSize(1,138/344))
            newLuaObj:setFunc(self.sortItemByIndex,CellNewTotalLogin)
            conFreeList_CellTotalLoginPanel:pushBack(cellElement)
            ItemIdx = ItemIdx + 1
        end 
    end

	conFreeList_CellTotalLoginPanel:update()
	conFreeList_CellTotalLoginPanel:getMoveElement():setPositionY(conFreeList_CellTotalLoginPanel:getMinPosition().y)

end


--@brief    其它Item点击回调
function CellNewTotalLogin:onOthersClick(luaTable,tag,tData)
    if tData == nil then
       return
    end
    local tagindex = tag+1
    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(luaTable.m_root,self.m_root,1,tData,false)
end

--@brief    奖励获取成功回调  
function CellNewTotalLogin:_GetRewardOk(  )
    CellNewTotalLogin.m_current_click.status[CellNewTotalLogin.m_current_click.m_currentIndex] = 1
    local imgItemkuang_sel = GetElement(self.m_root,"imgItemkuang_sel_"..CellNewTotalLogin.m_current_click.m_currentIndex,WZUIImage)
    imgItemkuang_sel:setFile("ui/strengthen/common_scale9duzaodi.png")
    local ImageItemIcon_Obj = GetElement(self.m_root,"ImageItemIcon_Obj_"..CellNewTotalLogin.m_current_click.m_currentIndex,WZUIImage)
    ImageItemIcon_Obj:setGrayRender(true)

    local ImageItemName_Obj = GetElement(self.m_root,"ImageItemName_Obj_"..CellNewTotalLogin.m_current_click.m_currentIndex,WZUIImage)
	ImageItemName_Obj:setFile("ui/common/commom_icon_ylq.png")
	ImageItemName_Obj:setRotation(28)
	ImageItemName_Obj:setAnchorPoint(GlobalMethod:ccp(0.5,0))
	ImageItemName_Obj:setRelativePosition(GlobalMethod:ccp(0.35,0))

	local armBox_CellTotalLoginPanel = GetElement(self.m_root,"armBox"..CellNewTotalLogin.m_current_click.m_currentIndex.."_CellTotalLoginPanel",WZArmature)
	armBox_CellTotalLoginPanel:setVisible(false)

	--WZLog("==================times===="..times)

	local txtMsgInfo_num_CellTotalLoginPanel = GetElement(CellNewTotalLogin.m_current_click.m_root,"txtMsgInfo_num_CellTotalLoginPanel",WZUILabelTTF)
	if txtMsgInfo_num_CellTotalLoginPanel ~= nil  then 
		local idx = self.count
		if idx < 8 then 
			txtMsgInfo_num_CellTotalLoginPanel:setText(string.format("%d",idx))
			local pos_index = CellNewTotalLogin.m_current_click.m_currentIndex+1
			if pos_index > 7 then 
				pos_index = 1 
			end 
			if CellNewTotalLogin.m_current_click.status[pos_index] == 0 then 
			else 
				local imgItemkuang_sel = GetElement(CellNewTotalLogin.m_current_click.m_root,"imgItemkuang_sel_"..pos_index,WZUIImage)
				imgItemkuang_sel:setFile("ui/strengthen/common_scale9duzaodi3.png")
			end 
			CellNewTotalLogin.m_current_click.m_currentIndex = pos_index
			CellNewTotalLogin.m_current_click:_UpdateItemReward(CellNewTotalLogin.m_current_click.m_currentIndex)
		end 
	end
end


function CellNewTotalLogin:_initStaticTxt( LoginTimes )
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


function CellNewTotalLogin:_setTabList(  )
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
            Items[DoneIdx].target=self.target[i]
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
            Items[DoingIdx].target=self.target[i]
            Items[DoingIdx].status = self.status[i]
            DoingIdx = DoingIdx +1
        end 
        end 
    end
end

--@brief    
function CellNewTotalLogin:sortItemByIndex( nIndex )
    WZLog("CellLoginActivityPanel:removeItemByIndex index="..nIndex)
    local size =  #CellNewTotalLogin.m_current.m_tRewardList.m_tDoingList
    local removePos = 0
    for i=1,size do
        if nIndex == CellNewTotalLogin.m_current.m_tRewardList.m_tDoingList[i].rewardId then 
            local len = #CellNewTotalLogin.m_current.m_tRewardList.m_tDoneList
            CellNewTotalLogin.m_current.m_tRewardList.m_tDoneList[len+1] = {}
            CellNewTotalLogin.m_current.m_tRewardList.m_tDoneList[len+1].rewardId = CellNewTotalLogin.m_current.m_tRewardList.m_tDoingList[i].rewardId
            CellNewTotalLogin.m_current.m_tRewardList.m_tDoneList[len+1].m_tData = CellNewTotalLogin.m_current.m_tRewardList.m_tDoingList[i].m_tData
            CellNewTotalLogin.m_current.m_tRewardList.m_tDoneList[len+1].status=1
            CellNewTotalLogin.m_current.m_tRewardList.m_tDoneList[len+1].tip=CellNewTotalLogin.m_current.m_tRewardList.m_tDoingList[i].tip
            removePos = i
        end 
    end
    table.remove(CellNewTotalLogin.m_current.m_tRewardList.m_tDoingList,removePos)
    CellNewTotalLogin.m_current:_UpdateItemReward()
end

function CellNewTotalLogin:onRuleClick(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndSingleMapDesc:showInterface(LocalStrings.TOTALLOGIN_DESC)
end

function CellNewTotalLogin:_adaptLanguage_vn(  )
    local txtMsgInfo_1 = GetElement(self.m_root,"txtMsgInfo_1_CellTotalLoginPanel",WZUILabelTTF)
    txtMsgInfo_1:setRelativePosition(GlobalMethod:ccp(0.025,0.8))
    txtMsgInfo_1:setScale(0.7)
    local txtMsgInfo_num = GetElement(self.m_root,"txtMsgInfo_num_CellTotalLoginPanel",WZUILabelTTF)
    txtMsgInfo_num:setRelativePosition(GlobalMethod:ccp(0.133,0.0999997))
    txtMsgInfo_num:setScale(0.7)
    local txtMsgInfo_2 = GetElement(self.m_root,"txtMsgInfo_2_CellTotalLoginPanel",WZUILabelTTF)
    txtMsgInfo_2:setRelativePosition(GlobalMethod:ccp(0.155,0.166667))
    txtMsgInfo_2:setScale(0.7)
end

function CellNewTotalLogin:_adaptLanguage_en(  )
    local txtMsgInfo_1 = GetElement(self.m_root,"txtMsgInfo_1_CellTotalLoginPanel",WZUILabelTTF)
    txtMsgInfo_1:setRelativePosition(GlobalMethod:ccp(0.025,0.8))
    txtMsgInfo_1:setScale(0.7)
    local txtMsgInfo_num = GetElement(self.m_root,"txtMsgInfo_num_CellTotalLoginPanel",WZUILabelTTF)
    txtMsgInfo_num:setRelativePosition(GlobalMethod:ccp(0.133,0.0999997))
    txtMsgInfo_num:setScale(0.7)
    local txtMsgInfo_2 = GetElement(self.m_root,"txtMsgInfo_2_CellTotalLoginPanel",WZUILabelTTF)
    txtMsgInfo_2:setRelativePosition(GlobalMethod:ccp(0.155,0.166667))
    txtMsgInfo_2:setScale(0.7)
end

function CellNewTotalLogin:_adaptLanguage_pt(  )
    local txtMsgInfo_1 = GetElement(self.m_root,"txtMsgInfo_1_CellTotalLoginPanel",WZUILabelTTF)
    txtMsgInfo_1:setRelativePosition(GlobalMethod:ccp(0.025,-0.0333333))
    txtMsgInfo_1:setScale(0.6)
    local txtMsgInfo_num = GetElement(self.m_root,"txtMsgInfo_num_CellTotalLoginPanel",WZUILabelTTF)
    txtMsgInfo_num:setRelativePosition(GlobalMethod:ccp(0.4,-0.0333333))
    txtMsgInfo_num:setScale(0.6)
    local txtMsgInfo_2 = GetElement(self.m_root,"txtMsgInfo_2_CellTotalLoginPanel",WZUILabelTTF)
    txtMsgInfo_2:setRelativePosition(GlobalMethod:ccp(0.422916,-0.0333333))
    txtMsgInfo_2:setScale(0.6)
end

function CellNewTotalLogin:_adaptLanguage_es(  )
    local txtMsgInfo_1 = GetElement(self.m_root,"txtMsgInfo_1_CellTotalLoginPanel",WZUILabelTTF)
    txtMsgInfo_1:setRelativePosition(GlobalMethod:ccp(0.025,-0.0333333))
    txtMsgInfo_1:setScale(0.6)
    local txtMsgInfo_num = GetElement(self.m_root,"txtMsgInfo_num_CellTotalLoginPanel",WZUILabelTTF)
    txtMsgInfo_num:setRelativePosition(GlobalMethod:ccp(0.333334,-0.0333333))
    txtMsgInfo_num:setScale(0.6)
    local txtMsgInfo_2 = GetElement(self.m_root,"txtMsgInfo_2_CellTotalLoginPanel",WZUILabelTTF)
    txtMsgInfo_2:setRelativePosition(GlobalMethod:ccp(0.358333,-0.0333333))
    txtMsgInfo_2:setScale(0.6)
end

function CellNewTotalLogin:_adaptLanguage_en(  )
    local txtMsgInfo_1 = GetElement(self.m_root,"txtMsgInfo_1_CellTotalLoginPanel",WZUILabelTTF)
    txtMsgInfo_1:setRelativePosition(GlobalMethod:ccp(0.025,0.5))
    txtMsgInfo_1:setScale(0.7)
    local txtMsgInfo_num = GetElement(self.m_root,"txtMsgInfo_num_CellTotalLoginPanel",WZUILabelTTF)
    txtMsgInfo_num:setRelativePosition(GlobalMethod:ccp(0.252084,0.5))
    txtMsgInfo_num:setScale(0.7)
    local txtMsgInfo_2 = GetElement(self.m_root,"txtMsgInfo_2_CellTotalLoginPanel",WZUILabelTTF)
    txtMsgInfo_2:setRelativePosition(GlobalMethod:ccp(0.277083,0.5))
    txtMsgInfo_2:setScale(0.7)
end
-------------------------------------私有方法模块End----------------------------------------
