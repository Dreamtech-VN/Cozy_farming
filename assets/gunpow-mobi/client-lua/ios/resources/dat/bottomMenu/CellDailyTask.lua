--CellDailyTask.lua
--@brief	CellDailyTask的UI模块
--@date		2014/09/05
--@author	SuYuan
--@note		每日任务Cell


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellDailyTask:onEnter(element)
	self.m_root = element

	self:_setStaticText()
	
    --多语言版本界面适配
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellDailyTask:onExit(element)
	self:_unInit()
end

--@brief	点击快速完成按钮的响应方法
--@param	element:快速完成按钮绑定的UI节点引用
--@note		点击快速完成按钮的响应方法
function CellDailyTask:onQuickComplete(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    if CacheCenter:getPlayerInfo().blueDiamond >= self.m_tTaskData.nDiamond then
    	local data = WZDataFile:getInstance():getUserData()
	    local sShowStatus = data:getStringValue("TaskTipData", "ShowQuickCompleteStatus")
	    if not (sShowStatus ~= nil and sShowStatus ~= "" and 0 == tonumber(sShowStatus)) then
	        local wndUpRewardElement = WndUpTaskRewards:createElement()
	        WndUpTaskRewards:setType(1)
	        WndUpTaskRewards:setCost(self.m_tTaskData.nDiamond)
	        WndUpTaskRewards:setCallback(self, self.quickCompleteCallback)
	        WindowManager:addWindow(wndUpRewardElement, WndUpTaskRewards)
	    else
            local _loadingId = MsgBoxManager:showLoadingBox()
            WndTask:setLoadingId(_loadingId)
	    	ProtocolProcessorWndTask:send_TASK_DiamondCompletion(self.m_tTaskData.nId)
	    end
    else
    	local wndRechargeElement = WndTaskRecharge:createElement()
    	WindowManager:addWindow(wndRechargeElement, WndTaskRecharge)
    end
end

--@brief	点击领奖按钮的响应方法
--@param	element:领奖按钮绑定的UI节点引用
--@note		点击领奖按钮的响应方法
function CellDailyTask:onGetReward(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local _loadingId = MsgBoxManager:showLoadingBox()
    WndTask:setLoadingId(_loadingId)
    --WZLog("CellDailyTask:onGetReward=============")
    for i=1,self.m_tTaskData.nItemCount do
        local idx = self.m_nTaskTopLevel*(i-1)+self.m_tTaskData.nUpLevel
        local itemNum = self.m_tTaskData.tUpCount[idx]
        --WZLog("CellDailyTask:onGetReward::"..itemNum)
        table.insert(m_tItemNum.m_tabDailyTaskItemNum,itemNum)
    end
    ProtocolProcessorWndTask:send_TASK_CommitTask(self.m_tTaskData.nId, self.m_tTaskData.nTaskType)
end

--@brief	点击提升领奖按钮的响应方法
--@param	element:提升领奖按钮绑定的UI节点引用
--@note		点击提升领奖按钮的响应方法
function CellDailyTask:onImproveReward(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WZLog("CellDailyTask:onImproveReward now_taskLevel="..self.m_tTaskData.nUpLevel..self.m_nTaskTopLevel)
    if (self.m_tTaskData.nUpLevel) >= (self.m_nTaskTopLevel) then
    	MsgBoxManager:showTipBox(LocalStrings.TASK_UPEXP_LIMIT, nil, nil, nil, nil)
    	return
    end
    WZLog("tExpend="..self.m_tTaskData.tExpend[self.m_tTaskData.nUpLevel+1])
    if CacheCenter:getPlayerInfo().blueDiamond >= self.m_tTaskData.tExpend[self.m_tTaskData.nUpLevel+1] then
    	local data = WZDataFile:getInstance():getUserData()
	    local sShowStatus = data:getStringValue("TaskTipData", "ShowUpRewardsStatus")
	    if not (sShowStatus ~= nil and sShowStatus ~= "" and 0 == tonumber(sShowStatus)) then
	        local wndUpRewardElement = WndUpTaskRewards:createElement()
	        WndUpTaskRewards:setType(2)
	        WndUpTaskRewards:setCost(self.m_tTaskData.tExpend[self.m_tTaskData.nUpLevel+1])
	        WndUpTaskRewards:setCallback(self, self.improveCallback)
	        WindowManager:addWindow(wndUpRewardElement, WndUpTaskRewards)
	    else
            local _nloadingId = MsgBoxManager:showLoadingBox()
            WndTask:setLoadingId(_nloadingId)
	    	ProtocolProcessorWndTask:send_TASK_QuickUpExp(self.m_tTaskData.nId)
	    end
    else
    	local wndRechargeElement = WndTaskRecharge:createElement()
    	WindowManager:addWindow(wndRechargeElement, WndTaskRecharge)
    end
end

--@brief 	快速完成弹窗确定回调
function CellDailyTask:quickCompleteCallback()
    --local _loadingId = MsgBoxManager:showLoadingBox(nil,WndTask,nil,nil,nil)
    local _loadingId = MsgBoxManager:showLoadingBox()
    WndTask:setLoadingId(_loadingId)
	ProtocolProcessorWndTask:send_TASK_DiamondCompletion(self.m_tTaskData.nId)
end

--@brief 	提升奖励弹窗确定回调
function CellDailyTask:improveCallback()
    local _nloadingId = MsgBoxManager:showLoadingBox()
    WndTask:setLoadingId(_nloadingId)
	ProtocolProcessorWndTask:send_TASK_QuickUpExp(self.m_tTaskData.nId)
end

--@brief 	设置任务数据
--@param 	tTaskData:任务数据
--@param 	nTaskStar:任务星级
--@param 	nTaskTopLevel:任务可提升最高等级
function CellDailyTask:setTaskData(tTaskData, nTaskStar, nTaskTopLevel)
    --WZLog("wwd::....--"..tTaskData.nTargetStatus)
	self.m_tTaskData = tTaskData
	self.m_nTaskTopLevel = nTaskTopLevel+1
    local now_taskLevel = tTaskData.nUpLevel
    --WZLog(" CellDailyTask:setTaskData nUpLevel="..now_taskLevel)
	--local tDailyTaskData = DailyTask["id_"..self.m_tTaskData.nId]
    self:_setTaskStar(nTaskStar)
    local desc = self:_getDailyTaskDesc()
	self:_setTaskDesc(desc)
    local tReward = {}
    local quality = {}
    self.tData = {}
    --local tRewardsNum = self:_getTaskCutRewardsNum()
    for i=1,self.m_tTaskData.nItemCount do
        --WZLog("CellDailyTask:setTaskData get nItemCount")
        local idx = self.m_nTaskTopLevel*(i-1)+now_taskLevel
    	--local tRewardItem = ShopItems["id_"..tDailyTaskData.reward[i][1]]
        local tRewardItem = ShopItems["id_"..tTaskData.tItemId[i]]
        local itemNum = tTaskData.tUpCount[idx]
        local data = {id = tTaskData.tItemId[i]}
        table.insert(self.tData,data)
    	--table.insert(tReward, {tRewardItem.name, tRewardItem.icon, tRewardsNum[i]})
        table.insert(tReward, {tRewardItem.name, tRewardItem.icon, itemNum})
        table.insert(quality,tRewardItem.quality)
    end
    self:_setTaskReward(tReward,quality)


    local diamondNum = 0

    if tTaskData.nTaskStatus == TASKSTATUS_DOING then
       diamondNum = tTaskData.nDiamond
    elseif tTaskData.nTaskStatus == TASKSTATUS_TOSUBMIT then
        if self.m_nTaskTopLevel == now_taskLevel then
            diamondNum = self.m_tTaskData.tExpend[self.m_nTaskTopLevel]
        else
            diamondNum = self.m_tTaskData.tExpend[self.m_tTaskData.nUpLevel+1]
        end
    end

    self:_setDiamondsNum(diamondNum)

    --@brief    提升等级最大时 按钮不能点击
    if now_taskLevel == self.m_nTaskTopLevel then
        GetElement(self.m_root,"btn_ImproveReward",WZUIButton):setTouchEnable(false)
    else
        GetElement(self.m_root,"btn_ImproveReward",WZUIButton):setTouchEnable(true)
    end
    
    self:_setTaskStatus(tTaskData.nId,self.m_tTaskData.nTaskStatus)

    GetElement(self.m_root,"txtToFinish_CellDailyTask",WZUILabelTTF):setText(LocalStrings.ACTIVE_BTN_GO)
    local ToId = DailyTask["id_"..tTaskData.nId].task_script[1]
    if ToId == 0 then --无需前往
        GetElement(self.m_root,"btn_tofinishTask",WZUIButton):setTouchEnable(false)
    else
        GetElement(self.m_root,"btn_tofinishTask",WZUIButton):setTouchEnable(true)
        self.b_CanToUI = true
    end
    --对id=15的日常任务的进度描述进行特殊处理
    if tTaskData.nId == 15 then
        GetElement(self.m_root,"icon_diamond",WZUI9Image):setVisible(false)
        GetElement(self.m_root,"txtDiamondlable",WZUILabelTTF):setVisible(false)
        GetElement(self.m_root,"btn_tofinishTask",WZUIButton):setVisible(false)
        if self.b_adaptLanguage_vn then
            GetElement(self.m_root,"txtDoing_CellDailyTask",WZUILabelTTF):setRelativePositionLuaTo(0.65,0.5)
            GetElement(self.m_root,"txtProgress_CellDailyTask",WZUILabelTTF):setRelativePositionLuaTo(0.7,0.5)
        else
            GetElement(self.m_root,"txtDoing_CellDailyTask",WZUILabelTTF):setRelativePositionLuaTo(0.2,0.5)
            GetElement(self.m_root,"txtProgress_CellDailyTask",WZUILabelTTF):setRelativePositionLuaTo(0.25,0.5)
        end
    else
        if self.b_adaptLanguage_vn  then
            GetElement(self.m_root,"txtDoing_CellDailyTask",WZUILabelTTF):setRelativePositionLuaTo(0.65,0.75)
            GetElement(self.m_root,"txtProgress_CellDailyTask",WZUILabelTTF):setRelativePositionLuaTo(0.7,0.75)
        elseif self.b_adaptLanguage_pt then
            GetElement(self.m_root,"txtDoing_CellDailyTask",WZUILabelTTF):setRelativePositionLuaTo(0.33,0.75)
            GetElement(self.m_root,"txtProgress_CellDailyTask",WZUILabelTTF):setRelativePositionLuaTo(0.4,0.75)
        else
            --GetElement(self.m_root,"icon_diamond",WZUI9Image):setVisible(true)
            --GetElement(self.m_root,"txtDiamondlable",WZUILabelTTF):setVisible(true)
            GetElement(self.m_root,"txtDoing_CellDailyTask",WZUILabelTTF):setRelativePositionLuaTo(-0.6,0.75)
            GetElement(self.m_root,"txtProgress_CellDailyTask",WZUILabelTTF):setRelativePositionLuaTo(-0.5,0.75)
            --GetElement(self.m_root,"txtDoing_CellDailyTask",WZUILabelTTF):setRelativePositionLuaTo(0,0.75)
            --GetElement(self.m_root,"txtProgress_CellDailyTask",WZUILabelTTF):setRelativePositionLuaTo(0.46,0.75)
        end
    end
   
    return desc
end

--@brief 	提升任务奖励
--@param 	tRewardsNum:任务物品数量
function CellDailyTask:improveTaskRewards(tRewardsNum)
	--for i,v in pairs(tRewardsNum) do
	--	GetElement(self.m_root, "txtItem"..i.."Num_CellDailyTask", WZUILabelTTF):setText("x"..v)
	--end
    if tRewardsNum == self.m_nTaskTopLevel then
        GetElement(self.m_root,"btn_ImproveReward",WZUIButton):setTouchEnable(false)
    end
    --WZLog("CellDailyTask:improveTaskRewards tRewardsNum="..tRewardsNum)
    for i=1,self.m_tTaskData.nItemCount do
        local idx = self.m_nTaskTopLevel*(i-1)+tRewardsNum
        local itemNum = self.m_tTaskData.tUpCount[idx]
        --WZLog("CellDailyTask:improveTaskRewards::::"..idx.."|"..itemNum)
        --GetElement(self.m_root, "txtItem"..i.."Num_CellDailyTask", WZUILabelTTF):setText("x"..itemNum)
        local conItem = GetElement(self.m_root, "con_dailytask_item_"..i, WZUIContainer)
        local celElement_obj = conItem:getChildByTag(i-1)
        if  celElement_obj ~= nil then
            celElement_obj = WZUIContainer:luaTo(celElement_obj)
            local tLuaObj_obj = celElement_obj:getLuaObjectIndex()
            tLuaObj_obj.m_txtCount:setText("x"..itemNum)
        end
    end 
    local diamondNum = 0
    if self.m_nTaskTopLevel == tRewardsNum then
        diamondNum = self.m_tTaskData.tExpend[self.m_nTaskTopLevel]
    else
        diamondNum = self.m_tTaskData.tExpend[tRewardsNum+1]
    end
    WZLog("CellDailyTask:improveTaskRewards=>"..diamondNum)
    self:_setDiamondsNum(diamondNum)
end

--@breif    前往按钮的点击事件
function CellDailyTask:event_finishTask()
    SoundManager:playEffectSound(SoundDefine.E_S_OPEN_WIN)
    
    
    WZLog("CellDailyTask:event_finishTask::"..self.m_tTaskData.nId)
    local m_nMainId = DailyTask["id_"..self.m_tTaskData.nId].task_script[1]
    local m_nSubId = DailyTask["id_"..self.m_tTaskData.nId].task_script[2]
    if self.b_CanToUI then
        if  m_nMainId == 27 then --聊天
            WndChat:showChatWindow()
        else   
            local jumpData = JUMP_LIST["id_"..m_nMainId.."_"..m_nSubId]
            if jumpData.uiName == "WndBag" then
                WndBag:showBag()    --可以显示玩家装备属性 by wuweidong
            elseif jumpData.uiName == "SceneCarton" then    --副本跳转
                --WZLog("CellTaskRewards:onBtnClick::SceneCarton")
                GlobalGame.g_tSysConfig.cartonTab = m_nSubId-1 
                JumpByUIId(m_nMainId, m_nSubId)
            elseif jumpData.uiName == "ScenePet" then
                --发送退出房间协议
                SceneRoom:onBackSceneCallback(true)
                SceneBossRoom:onBackScene(true)
                local index = 4
                local isMove = true
                CheckLuaLoad(LUAFILES_BLOCK_COMMON)
                CheckLuaLoad(Chat_Channel_Pet)
                ScenePet:showPageConCenterPos( index , isMove )
            else
                JumpByUIId(m_nMainId,m_nSubId)
            end
        end
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	设置界面上的静态文本
function CellDailyTask:_setStaticText()
	GetElement(self.m_root, "txtDoing_CellDailyTask", WZUILabelTTF):setText(LocalStrings.TASK_DOING)
	GetElement(self.m_root, "txtQuickComplete_CellDailyTask", WZUILabelTTF):setText(LocalStrings.TASK_QUICKCOMPLETE)
	GetElement(self.m_root, "txtGetReward_CellDailyTask", WZUILabelTTF):setText(LocalStrings.GET_REWARD)
	GetElement(self.m_root, "txtImproveReward_CellDailyTask", WZUILabelTTF):setText(LocalStrings.IMPROVE_REWARD)
end

--@brief 	设置任务星级
--@param 	nTaskStar:任务星级
function CellDailyTask:_setTaskStar(nTaskStar)
	for i=1,5,1 do
		if i <= nTaskStar then
			GetElement(self.m_root, "imgStar"..i.."_CellDailyTask", WZUIImage):setFile("ui/main/strengthen/strengthen_star.png")
		else
			GetElement(self.m_root, "imgStar"..i.."_CellDailyTask", WZUIImage):setFile("ui/main/strengthen/strengthen_star_not.png")
		end
	end
end

--@brief 	设置任务描述
--@param 	sTaskDesc:任务描述
function CellDailyTask:_setTaskDesc(sTaskDesc)
	GetElement(self.m_root, "txtTaskDesc_CellDailyTask", WZUILabelTTF):setText(sTaskDesc)
end

--@brief 	设置任务奖励
--@param 	tTaskReward:任务奖励（结构：{{"奖励1名称", "奖励1图片路径", "奖励1数量"}, {"奖励2名称", "奖励2图片路径", "奖励2数量"}, ...}）
function CellDailyTask:_setTaskReward(tTaskReward,quality)
	for i,v in pairs(tTaskReward) do
        --[[local coler = GlobalMethod:ccc3(255,255,255)
        if quality[i] == 1 then
            coler = GlobalMethod:ccc3(131,255,0)
        elseif quality[i] == 2 then
            coler = GlobalMethod:ccc3(0,176,240)
        elseif quality[i] == 3 then
            coler = GlobalMethod:ccc3(255,0,174)
        elseif quality[i] == 4 then
            coler = GlobalMethod:ccc3(255,204,0)
        else
            coler = GlobalMethod:ccc3(255,255,255)
        end]]
		--[[local txtItem_name = GetElement(self.m_root, "txtItem"..i.."Name_CellDailyTask", WZUILabelTTF)
        if txtItem_name ~= nil then
            txtItem_name:setText(v[1])
            txtItem_name:setColor(coler)
        end
		GetElement(self.m_root, "imgItem"..i.."Icon_CellDailyTask", WZUIImage):setFile(v[2])
		GetElement(self.m_root, "txtItem"..i.."Num_CellDailyTask", WZUILabelTTF):setText("x"..v[3])
        self:_setQuality(i,quality[i])]]

        local conItem = GetElement(self.m_root, "con_dailytask_item_"..i, WZUIContainer)
        local itemInfo = {id=self.tData[i].id, name=v[1],icon=v[2],lastTime=v[3],quality=quality[i]} 
        
        local celElement_obj = conItem:getChildByTag(i-1)

        if  celElement_obj ~= nil then
            celElement_obj = WZUIContainer:luaTo(celElement_obj)
            local tLuaObj_obj = celElement_obj:getLuaObjectIndex()
            tLuaObj_obj:setCellGoodItem(itemInfo,4)
            tLuaObj_obj:setItemClickFun(self,self.onOthersClick)
        else
            local celElement,tLuaObj = CellGoodItem:createElement()
            if celElement ~= nil then 
                celElement = WZUIContainer:luaTo(celElement)
                tLuaObj:setCellGoodItem(itemInfo,4)
                celElement:setTag(i-1)
                tLuaObj:setItemClickFun(self,self.onOthersClick)
                conItem:addChild(celElement)
            end
        end
	end
end


--@brief    其它Item点击回调
function CellDailyTask:onOthersClick(luaTable,tag,tData)
    if tData == nil then
       return
    end
    local tagindex = tag+1
    --local conItem = GetElement(self.m_root, "conItem"..tagindex.."_CellTaskRewards", WZUIContainer)
    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(luaTable.m_root,WndTask.m_root,1,tData,false)

end
--@brief 	设置任务状态
--@param 	nTaskStatus:任务状态（TASKSTATUS_DOING:进行中, TASKSTATUS_TOSUBMIT:待提交, TASKSTATUS_COMPLETED:已完成，定义见GlobalDefine.lua）
function CellDailyTask:_setTaskStatus(nId,nTaskStatus)
	local img9CompletedBg = GetElement(self.m_root, "img9CompletedBg_CellDailyTask", WZUI9Image)
	img9CompletedBg:setVisible(false)
	local conDoing = GetElement(self.m_root, "conDoing_CellDailyTask", WZUIContainer)
	local conToSubmit = GetElement(self.m_root, "conToSubmit_CellDailyTask", WZUIContainer)
	local conFinished = GetElement(self.m_root, "conCompleted_CellDailyTask", WZUIContainer)
	conDoing:setVisible(false)
	conToSubmit:setVisible(false)
	conFinished:setVisible(false)

	if nTaskStatus == TASKSTATUS_DOING then
		conDoing:setVisible(true)
		self:_setDoingProgress(self.m_tTaskData.nTargetStatus[1], self.m_tTaskData.nTargetValue[1])
		local btnQuickComplete = GetElement(self.m_root, "btnQuickComplete_CellDailyTask", WZUIButton)
		if self.m_tTaskData.nDiamond < 1 then
			btnQuickComplete:setVisible(false)
		else
			btnQuickComplete:setVisible(true)
		end
	elseif nTaskStatus == TASKSTATUS_TOSUBMIT then
		conToSubmit:setVisible(true)
        if nId == 15 then
            GetElement(self.m_root,"btn_SubmitTask",WZUIButton):setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
            GetElement(self.m_root,"btn_SubmitTask",WZUIButton):setRelativePosition(GlobalMethod:ccp(0.5,0.5))
            GetElement(self.m_root,"btn_ImproveReward",WZUIButton):setVisible(false)
        end
        --GetElement(self.m_root,"icon_diamond",WZUI9Image):setVisible(true)
        --GetElement(self.m_root,"txtDiamondlable",WZUILabelTTF):setVisible(true)
	elseif nTaskStatus == TASKSTATUS_COMPLETED then
		img9CompletedBg:setVisible(true)
		conFinished:setVisible(true)
        GetElement(self.m_root,"icon_diamond",WZUI9Image):setVisible(false)
        GetElement(self.m_root,"txtDiamondlable",WZUILabelTTF):setVisible(false)
	end
end

--@brief 	设置正在进行中任务的进度
--@param 	nProgress:任务进度
--@param 	nGoals:任务目标
function CellDailyTask:_setDoingProgress(nProgress, nGoals)
    --WZLog("CellDailyTask:_setDoingProgress::"..nProgress.."/"..nGoals)
	GetElement(self.m_root, "txtProgress_CellDailyTask", WZUILabelTTF):setText(nProgress.."/"..nGoals)
end

--@brief 	获取每日任务描述
function CellDailyTask:_getDailyTaskDesc()
	local sDesc = ""
	local tDailyTaskData = DailyTask["id_"..self.m_tTaskData.nId]
    --modify by wuweidong  将self.m_tTaskData.nTargetType改为ntasksubtype
    --WZLog("wwd::..".."|"..self.m_tTaskData.nTaskSubType)
	local tDailyTaskTypeData = DailyTaskTypeData["id_"..self.m_tTaskData.nId.."_"..self.m_tTaskData.nTaskSubType.."_"..self.m_tTaskData.nTargetType]

    WZLog("CellDailyTask:_getDailyTaskDesc", self.m_tTaskData.nId, "id_"..self.m_tTaskData.nId.."_"..self.m_tTaskData.nTaskSubType.."_"..self.m_tTaskData.nTargetType, tostring(tDailyTaskData), tostring(tDailyTaskTypeData))

	--if 1 == self.m_tTaskData.nId then
    --if 1 == self.m_tTaskData.nId then
    --WZLog("CellDailyTask:_getDailyTaskDesc::=>nTargetValue="..self.m_tTaskData.nTargetValue[1])
    if tDailyTaskTypeData ~= nil then
        sDesc = string.format(tDailyTaskData.target_desc, tDailyTaskTypeData.type_name, self.m_tTaskData.nTargetValue[1],tDailyTaskTypeData.target_name)
    else
        sDesc = ""
    end
    --elseif  self.m_tTaskData.nId < 4 then
	--	sDesc = string.format(tDailyTaskData.target_desc, tDailyTaskTypeData.type_name, tDailyTaskTypeData.target_name)
	--else
	--	sDesc = string.format(tDailyTaskData.target_desc, tDailyTaskTypeData.type_name)
	--end

	return sDesc
end

--@brief 	获取当前任务奖励的数量
--@note  	根据任务已经提升的等级获取任务当前奖励的数量
function CellDailyTask:_getTaskCutRewardsNum()
	local tRewardsNum = {}
  	
  	--已经提升过任务等级
	if (not self.m_tTaskData.nUpLevel==nil)and self.m_tTaskData.nUpLevel > 0 then
		for i=0,self.m_tTaskData.nItemCount-1 do
			table.insert(tRewardsNum, self.m_tTaskData.tUpCount[self.m_tTaskData.nUpLevel+(i*self.m_nTaskTopLevel)])
		end

	--没有提升过任务等级
	else
		local tDailyTaskData = DailyTask["id_"..self.m_tTaskData.nId]
		for i=1,self.m_tTaskData.nItemCount do
			table.insert(tRewardsNum, tDailyTaskData.reward[i][2])
    	end
    end

	return tRewardsNum
end
--[[
--@brief    最左边item的点击事件
function CellDailyTask:TipsFunc_Left(element)
    --WndItemInfo:showInfo(element,WndTask.m_root,1,self.tData[1],false)
end

--@brief   中间item的点击事件
function CellDailyTask:TipsFunc_Center(element)
    --WndItemInfo:showInfo(element,WndTask.m_root,1,self.tData[2],false)
end

--@brief    最右边item的点击事件
function CellDailyTask:TipsFunc_Right(element)
    -- body
    --WndItemInfo:showInfo(element,WndTask.m_root,1,self.tData[3],false)
end

--设置父节点
function CellDailyTask:setparentelement(nelement)
   self.m_parentelement = nelement
end
]]
-------------------------------------私有方法模块End----------------------------------------
--@brief 物品品质
--[[function CellDailyTask:_setQuality(idx,quality)
    if quality == nil then
       quality = 0
    end
    local btnImg1 = self.m_root:getChildElement("btnImg"..idx.."_CellGood")
    if btnImg1 then
        if quality == 1 then
            btnImg1 = WZUI9Image:luaTo(btnImg1)
            btnImg1:setFile("common/Jigsaw/n_items_a.png")
        elseif quality == 2 then
        
            btnImg1 = WZUI9Image:luaTo(btnImg1)
            btnImg1:setFile("common/Jigsaw/n_items_b.png")
            
      
        elseif quality == 3 then
        
            btnImg1 = WZUI9Image:luaTo(btnImg1)
            btnImg1:setFile("common/Jigsaw/n_items_c.png")
           
        
        elseif quality == 4 then
       
            btnImg1 = WZUI9Image:luaTo(btnImg1)
            btnImg1:setFile("common/Jigsaw/n_items_d.png")
           
        else
            btnImg1 = WZUI9Image:luaTo(btnImg1)
            btnImg1:setFile("common/Jigsaw/n_items01.png")
            
        end
    end
end]]


-------------------------------------语言适配模块Begin----------------------------------------

--@brief    设置蓝砖数值
function CellDailyTask:_setDiamondsNum(nNum)
    local txtNum = string.format("%d",nNum)
    GetElement(self.m_root,"txtDiamondlable",WZUILabelTTF):setText(txtNum)
    GetElement(self.m_root,"icon_diamond",WZUI9Image):setVisible(true)
    GetElement(self.m_root,"txtDiamondlable",WZUILabelTTF):setVisible(true)
    GetElement(self.m_root,"btn_tofinishTask",WZUIButton):setVisible(true)
end

--@brief	英文适配函数
--@note		英文适配函数
function CellDailyTask:_adaptLanguage_en()
    self.b_adaptLanguage_en = true
    GetElement(self.m_root, "txtImproveReward_CellDailyTask", WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root, "txtImproveReward_CellDailyTask", WZUILabelTTF):setDimensions(GlobalMethod:CCSize(145,0))

    if not (self.m_tTaskData.nId == 15) then
        --GetElement(self.m_root,"txtDoing_CellDailyTask",WZUILabelTTF):setRelativePositionLuaTo(0.22,0.75)
        --GetElement(self.m_root,"txtProgress_CellDailyTask",WZUILabelTTF):setRelativePositionLuaTo(0.45,0.75)
    end
end

--@brief    越南语的适配
function CellDailyTask:_adaptLanguage_vn( )
    self.b_adaptLanguage_vn = true
    GetElement(self.m_root, "txtImproveReward_CellDailyTask", WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root, "txtImproveReward_CellDailyTask", WZUILabelTTF):setDimensions(GlobalMethod:CCSize(145,0))
    GetElement(self.m_root, "txtQuickComplete_CellDailyTask", WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root, "txtQuickComplete_CellDailyTask", WZUILabelTTF):setDimensions(GlobalMethod:CCSize(145,0))
    if self.m_tTaskData.nId == 15 then
        GetElement(self.m_root,"txtDoing_CellDailyTask",WZUILabelTTF):setRelativePositionLuaTo(0.65,0.5)
        GetElement(self.m_root,"txtProgress_CellDailyTask",WZUILabelTTF):setRelativePositionLuaTo(0.7,0.5)
    else
        GetElement(self.m_root,"txtDoing_CellDailyTask",WZUILabelTTF):setRelativePositionLuaTo(0.65,0.75)
        GetElement(self.m_root,"txtProgress_CellDailyTask",WZUILabelTTF):setRelativePositionLuaTo(0.7,0.75)
    end
end

function CellDailyTask:_adaptLanguage_pt(  )
    self.b_adaptLanguage_pt = true
    GetElement(self.m_root, "txtImproveReward_CellDailyTask", WZUILabelTTF):setFontSize(20)
    GetElement(self.m_root, "txtImproveReward_CellDailyTask", WZUILabelTTF):setDimensions(GlobalMethod:CCSize(145,0))
    GetElement(self.m_root, "txtQuickComplete_CellDailyTask", WZUILabelTTF):setFontSize(20)
    GetElement(self.m_root, "txtQuickComplete_CellDailyTask", WZUILabelTTF):setDimensions(GlobalMethod:CCSize(145,0))
    GetElement(self.m_root, "txtGetReward_CellDailyTask", WZUILabelTTF):setFontSize(20)
    if self.m_tTaskData.nId == 15 then
        GetElement(self.m_root,"txtDoing_CellDailyTask",WZUILabelTTF):setRelativePositionLuaTo(0.65,0.5)
        GetElement(self.m_root,"txtProgress_CellDailyTask",WZUILabelTTF):setRelativePositionLuaTo(0.7,0.5)
    else
        GetElement(self.m_root,"txtDoing_CellDailyTask",WZUILabelTTF):setRelativePositionLuaTo(0.33,0.75)
        GetElement(self.m_root,"txtProgress_CellDailyTask",WZUILabelTTF):setRelativePositionLuaTo(0.4,0.75)
    end
end
-------------------------------------语言适配模块End----------------------------------------



