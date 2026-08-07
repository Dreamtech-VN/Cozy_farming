--CellAmberPlayer.lua
--@brief	CellAmberPlayer的UI模块
--@date		2020/09/16
--@author	nijinlin
--@note		oppo琥珀大玩家


-------------------------------------公有方法模块Begin--------------------------------------
-- CellAmberPlayer={}
--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellAmberPlayer:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellAmberPlayer:onExit(element)
	self:_unInit()
end

--@brief onEnter函数执行完成回调
function CellAmberPlayer:onEnterTransitionDidFinish(element)
end

--@brief    显示窗口
function CellAmberPlayer:showWindow()
	local LoginTimes = self.count
	self:_initStaticTxt(LoginTimes)
    self:_setTabList(  )

    self:_UpdateItemReward(self.m_currentIndex)

    if g_tGameActivityTypes and self.typeId and self.typeId == g_tGameActivityTypes.ACTIVITY_OPPO_BIGVIP_WELFARE then
        --针对琥珀大玩家大会员福利活动，隐藏上方累计签到XX天
        local con = GetElement(self.m_root,"conMsgInfo_CellAmberPlayer",WZUIContainer)
        if con then
            con:setVisible(false)
        end
        local btnRule_CellAmberPlayer = GetElement(self.m_root,"btnRule_CellAmberPlayer",WZUIButton)
        if btnRule_CellAmberPlayer then
            btnRule_CellAmberPlayer:setVisible(false)
        end
    end
end


function CellAmberPlayer:Event_Done( element )
    WZLog("********** CellAmberPlayer:Event_Done ***********")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	CellAmberPlayer.m_current_click = self
	local tag = element:getTag()
	local statusIndex = self.status[tag]
    WZLog("********** CellAmberPlayer:Event_Done 111 ***********", statusIndex, self.m_currentIndex, tag)
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
function CellAmberPlayer:_UpdateItemReward( index )
    WZLog("CellAmberPlayer:_UpdateItemReward  ", index)
    local tag = index
	local conFreeList_CellAmberPlayer = GetElement(self.m_root,"conFreeList_CellAmberPlayer",WZUIFreeListContainer)
	
	if conFreeList_CellAmberPlayer:size() > 0 then 
		conFreeList_CellAmberPlayer:removeAll()
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
            --WZLog("****** ItemTab.tip *********-1", ItemTab.tip, index)
            --OV琥珀大玩家，临时手动隐藏游戏中心特权活动-
            if ItemTab.tip and tostring(ItemTab.tip) ~= "游戏中心特权" then
                local cellElement,newLuaObj = CellGradePanelItem:createElement()
                cellElement = WZUIContainer:luaTo(cellElement)
                WZLog("****** SSSSSSSSSS *********",ItemTab.rewardId, self.rewardId[i], i,ItemTab.tip, self.index, index, self.typeId)
                --local sDays = tostring(ItemTab.rewardId + 1)
                newLuaObj:setUIType(2)
                local sDays = ItemTab.target
                if g_tGameActivityTypes and self.typeId and self.typeId == g_tGameActivityTypes.ACTIVITY_OPPO_BIGVIP_WELFARE then --typeId 6112,6113,6114:大会员福利，大会员签到，大会员充值
                    WZLog("****** SSSSSSSSSS ItemTab.status*********",ItemTab.status)
                    sDays = ItemTab.tip
                    newLuaObj:setUIType(1)
                end
                --WZLog("ksljekkkkk",Serialize(ItemTab))
                newLuaObj:setMessage_amberPlayer(self.typeId,ItemIdx,ItemTab.rewardId,ItemTab.m_tData,sDays,ItemTab.status,self.index,self.m_cellItemObj)
                cellElement:setTag(ItemIdx-1)
                -- cellElement:setContentSize(GlobalMethod:CCSize(626,122))
                cellElement:setRelativeSize(GlobalMethod:CCSize(1,0.35))
                newLuaObj:setFunc(self.sortItemByIndex,CellAmberPlayer)
                conFreeList_CellAmberPlayer:pushBack(cellElement)
            end
            ItemIdx = ItemIdx + 1
        end 
    end

	conFreeList_CellAmberPlayer:update()
	conFreeList_CellAmberPlayer:getMoveElement():setPositionY(conFreeList_CellAmberPlayer:getMinPosition().y)

end


--@brief    其它Item点击回调
function CellAmberPlayer:onOthersClick(luaTable,tag,tData)
    if tData == nil then
       return
    end
    local tagindex = tag+1
    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(luaTable.m_root,self.m_root,1,tData,false)
end

--@brief    奖励获取成功回调  
function CellAmberPlayer:_GetRewardOk(  )
    CellAmberPlayer.m_current_click.status[CellAmberPlayer.m_current_click.m_currentIndex] = 1
    local imgItemkuang_sel = GetElement(self.m_root,"imgItemkuang_sel_"..CellAmberPlayer.m_current_click.m_currentIndex,WZUIImage)
    imgItemkuang_sel:setFile("ui/strengthen/common_scale9duzaodi.png")
    local ImageItemIcon_Obj = GetElement(self.m_root,"ImageItemIcon_Obj_"..CellAmberPlayer.m_current_click.m_currentIndex,WZUIImage)
    ImageItemIcon_Obj:setGrayRender(true)

    local ImageItemName_Obj = GetElement(self.m_root,"ImageItemName_Obj_"..CellAmberPlayer.m_current_click.m_currentIndex,WZUIImage)
	ImageItemName_Obj:setFile("ui/common/commom_icon_ylq.png")
	ImageItemName_Obj:setRotation(28)
	ImageItemName_Obj:setAnchorPoint(GlobalMethod:ccp(0.5,0))
	ImageItemName_Obj:setRelativePosition(GlobalMethod:ccp(0.35,0))

	local armBox_CellAmberPlayer = GetElement(self.m_root,"armBox"..CellAmberPlayer.m_current_click.m_currentIndex.."_CellAmberPlayer",WZArmature)
	armBox_CellAmberPlayer:setVisible(false)

	--WZLog("==================times===="..times)

	local txtMsgInfo_num_CellAmberPlayer = GetElement(CellAmberPlayer.m_current_click.m_root,"txtMsgInfo_num_CellAmberPlayer",WZUILabelTTF)
	if txtMsgInfo_num_CellAmberPlayer ~= nil  then 
		local idx = self.count
		if idx < 8 then 
			txtMsgInfo_num_CellAmberPlayer:setText(string.format("%d",idx))
			local pos_index = CellAmberPlayer.m_current_click.m_currentIndex+1
			if pos_index > 7 then 
				pos_index = 1 
			end 
			if CellAmberPlayer.m_current_click.status[pos_index] == 0 then 
			else 
				local imgItemkuang_sel = GetElement(CellAmberPlayer.m_current_click.m_root,"imgItemkuang_sel_"..pos_index,WZUIImage)
				imgItemkuang_sel:setFile("ui/strengthen/common_scale9duzaodi3.png")
			end 
			CellAmberPlayer.m_current_click.m_currentIndex = pos_index
			CellAmberPlayer.m_current_click:_UpdateItemReward(CellAmberPlayer.m_current_click.m_currentIndex)
		end 
	end
end


function CellAmberPlayer:_initStaticTxt( LoginTimes )
	local m_tTxtInfo = {LocalStrings.ACTIVITY_CUMULATIVE_LOGIN,
						LocalStrings.ACTIVITY_CUMULATIVE_LOGIN_CP}
	for i=1,2 do
		local txtMsgInfo_CellAmberPlayer = GetElement(self.m_root,"txtMsgInfo_"..i.."_CellAmberPlayer",WZUILabelTTF)
		if txtMsgInfo_CellAmberPlayer ~= nil then 
			txtMsgInfo_CellAmberPlayer:setText(m_tTxtInfo[i])
		end 
	end

	local txtMsgInfo_num_CellAmberPlayer = GetElement(self.m_root,"txtMsgInfo_num_CellAmberPlayer",WZUILabelTTF)
	if txtMsgInfo_num_CellAmberPlayer ~= nil  then 
		txtMsgInfo_num_CellAmberPlayer:setText(string.format("%d",LoginTimes))
	end 

    --活动时间
    local txtActivityTime = GetElement(self.m_root, "txtActivityTime_CellAmberPlayer", WZUILabelTTF)
    txtActivityTime:setText(LocalStrings.ACTIVE_TIME .. ":")
    --具体日期
    local txtTimeValue = GetElement(self.m_root, "txtTimeValue_CellAmberPlayer", WZUILabelTTF)
    local DayStartTab = os.date("*t",self.m_nStartTime)
    local DayEndTab = os.date("*t",self.m_nEndTime)
    local sTimeValue = string.format(LocalStrings.ACTIVITYTIME_FORMAT, DayStartTab.month, DayStartTab.day, DayStartTab.hour, DayStartTab.min, DayEndTab.month, DayEndTab.day, DayEndTab.hour, DayEndTab.min)
    txtTimeValue:setText(sTimeValue)
end


function CellAmberPlayer:_setTabList(  )
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
function CellAmberPlayer:sortItemByIndex( nIndex )
    WZLog("CellLoginActivityPanel:removeItemByIndex index="..nIndex)
    local size =  #CellAmberPlayer.m_current.m_tRewardList.m_tDoingList
    local removePos = 0
    for i=1,size do
        if nIndex == CellAmberPlayer.m_current.m_tRewardList.m_tDoingList[i].rewardId then 
            local len = #CellAmberPlayer.m_current.m_tRewardList.m_tDoneList
            CellAmberPlayer.m_current.m_tRewardList.m_tDoneList[len+1] = {}
            CellAmberPlayer.m_current.m_tRewardList.m_tDoneList[len+1].rewardId = CellAmberPlayer.m_current.m_tRewardList.m_tDoingList[i].rewardId
            CellAmberPlayer.m_current.m_tRewardList.m_tDoneList[len+1].m_tData = CellAmberPlayer.m_current.m_tRewardList.m_tDoingList[i].m_tData
            CellAmberPlayer.m_current.m_tRewardList.m_tDoneList[len+1].status=1
            CellAmberPlayer.m_current.m_tRewardList.m_tDoneList[len+1].tip=CellAmberPlayer.m_current.m_tRewardList.m_tDoingList[i].tip
            removePos = i
        end 
    end
    table.remove(CellAmberPlayer.m_current.m_tRewardList.m_tDoingList,removePos)
    CellAmberPlayer.m_current:_UpdateItemReward()
end

function CellAmberPlayer:onRuleClick(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndSingleMapDesc:showInterface(LocalStrings.TOTALLOGIN_DESC)
end

function CellAmberPlayer:_adaptLanguage_vn(  )
    local txtMsgInfo_1 = GetElement(self.m_root,"txtMsgInfo_1_CellAmberPlayer",WZUILabelTTF)
    txtMsgInfo_1:setRelativePosition(GlobalMethod:ccp(0.025,0.8))
    txtMsgInfo_1:setScale(0.7)
    local txtMsgInfo_num = GetElement(self.m_root,"txtMsgInfo_num_CellAmberPlayer",WZUILabelTTF)
    txtMsgInfo_num:setRelativePosition(GlobalMethod:ccp(0.133,0.0999997))
    txtMsgInfo_num:setScale(0.7)
    local txtMsgInfo_2 = GetElement(self.m_root,"txtMsgInfo_2_CellAmberPlayer",WZUILabelTTF)
    txtMsgInfo_2:setRelativePosition(GlobalMethod:ccp(0.155,0.166667))
    txtMsgInfo_2:setScale(0.7)
end

function CellAmberPlayer:_adaptLanguage_en(  )
    local txtMsgInfo_1 = GetElement(self.m_root,"txtMsgInfo_1_CellAmberPlayer",WZUILabelTTF)
    txtMsgInfo_1:setRelativePosition(GlobalMethod:ccp(0.025,0.8))
    txtMsgInfo_1:setScale(0.7)
    local txtMsgInfo_num = GetElement(self.m_root,"txtMsgInfo_num_CellAmberPlayer",WZUILabelTTF)
    txtMsgInfo_num:setRelativePosition(GlobalMethod:ccp(0.133,0.0999997))
    txtMsgInfo_num:setScale(0.7)
    local txtMsgInfo_2 = GetElement(self.m_root,"txtMsgInfo_2_CellAmberPlayer",WZUILabelTTF)
    txtMsgInfo_2:setRelativePosition(GlobalMethod:ccp(0.155,0.166667))
    txtMsgInfo_2:setScale(0.7)
end

function CellAmberPlayer:_adaptLanguage_pt(  )
    local txtMsgInfo_1 = GetElement(self.m_root,"txtMsgInfo_1_CellAmberPlayer",WZUILabelTTF)
    txtMsgInfo_1:setRelativePosition(GlobalMethod:ccp(0.025,-0.0333333))
    txtMsgInfo_1:setScale(0.6)
    local txtMsgInfo_num = GetElement(self.m_root,"txtMsgInfo_num_CellAmberPlayer",WZUILabelTTF)
    txtMsgInfo_num:setRelativePosition(GlobalMethod:ccp(0.4,-0.0333333))
    txtMsgInfo_num:setScale(0.6)
    local txtMsgInfo_2 = GetElement(self.m_root,"txtMsgInfo_2_CellAmberPlayer",WZUILabelTTF)
    txtMsgInfo_2:setRelativePosition(GlobalMethod:ccp(0.422916,-0.0333333))
    txtMsgInfo_2:setScale(0.6)
end

function CellAmberPlayer:_adaptLanguage_es(  )
    local txtMsgInfo_1 = GetElement(self.m_root,"txtMsgInfo_1_CellAmberPlayer",WZUILabelTTF)
    txtMsgInfo_1:setRelativePosition(GlobalMethod:ccp(0.025,-0.0333333))
    txtMsgInfo_1:setScale(0.6)
    local txtMsgInfo_num = GetElement(self.m_root,"txtMsgInfo_num_CellAmberPlayer",WZUILabelTTF)
    txtMsgInfo_num:setRelativePosition(GlobalMethod:ccp(0.333334,-0.0333333))
    txtMsgInfo_num:setScale(0.6)
    local txtMsgInfo_2 = GetElement(self.m_root,"txtMsgInfo_2_CellAmberPlayer",WZUILabelTTF)
    txtMsgInfo_2:setRelativePosition(GlobalMethod:ccp(0.358333,-0.0333333))
    txtMsgInfo_2:setScale(0.6)
end

function CellAmberPlayer:_adaptLanguage_en(  )
    local txtMsgInfo_1 = GetElement(self.m_root,"txtMsgInfo_1_CellAmberPlayer",WZUILabelTTF)
    txtMsgInfo_1:setRelativePosition(GlobalMethod:ccp(0.025,0.5))
    txtMsgInfo_1:setScale(0.7)
    local txtMsgInfo_num = GetElement(self.m_root,"txtMsgInfo_num_CellAmberPlayer",WZUILabelTTF)
    txtMsgInfo_num:setRelativePosition(GlobalMethod:ccp(0.252084,0.5))
    txtMsgInfo_num:setScale(0.7)
    local txtMsgInfo_2 = GetElement(self.m_root,"txtMsgInfo_2_CellAmberPlayer",WZUILabelTTF)
    txtMsgInfo_2:setRelativePosition(GlobalMethod:ccp(0.277083,0.5))
    txtMsgInfo_2:setScale(0.7)
end
-------------------------------------私有方法模块End----------------------------------------
