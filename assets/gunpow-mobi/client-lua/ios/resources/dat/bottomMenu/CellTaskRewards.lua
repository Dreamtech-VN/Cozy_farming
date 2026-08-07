--CellTaskRewards.lua
--@brief	CellTaskRewards的UI模块
--@date		2014/09/09
--@author	SuYuan
--@note		主线任务奖励Cell


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellTaskRewards:onEnter(element)
	self.m_root = element

	self:_setStaticText()
	
    --多语言版本界面适配
    AdaptLanguage(self)
    
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellTaskRewards:onExit(element)
	self:_unInit()
    Teach:isStartTeach("CellTaskRewards:onExit")
end

--@brief	点击按钮的响应方法
--@param	element:按钮绑定的UI节点引用
--@note		点击按钮的响应方法
function CellTaskRewards:onBtnClick(element)
	WZLog("CellTaskRewards:onBtnClick")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    --WZLog("CellTaskRewards:onBtnClick"..self.m_nMainID..self.m_nSubID)

    if self.m_nMainID == 7 then --公会
        --发送退出房间协议
        SceneRoom:onBackSceneCallback(true)
        SceneBossRoom:onBackScene(true)

    	CheckLuaLoad(LUAFILES_BLOCK_COMMON)
        CheckLuaLoad(Chat_Channel_Community)
        SceneCommunity:onJumpToCommunity()
    elseif self.m_nMainID == 8 then
        WndMarryManager:initManager()
        WndMarryManager:createLoading()
    elseif self.m_nMainID == 21 then
        WndStrong:showInterface()
    elseif self.m_nMainID == 23 then
        WndExChange:ShowExChange()
    elseif self.m_nMainID == 27 then
        WndChat:showChatWindow()
    elseif self.m_nMainID == 29 then
        WndWeibo:showInterface()
	elseif self.m_nMainID > -1 and self.m_nSubID > -1 then
		--modify by wuweidong	添加jumpData = "wndBag"
		WZLog("CellTaskRewards:onBtnClick::".."MainId="..self.m_nMainID.."|SubId="..self.m_nSubID)
		local jumpData = JUMP_LIST["id_"..self.m_nMainID.."_"..self.m_nSubID]
		if jumpData.uiName == "WndBag" then
			WndBag:showBag()	--可以显示玩家装备属性 by wuweidong
		elseif jumpData.uiName == "SceneCarton" then	--副本跳转
			--WZLog("CellTaskRewards:onBtnClick::SceneCarton") 
            local target = MainTask["id_"..self.CartorNeedId].target
            local targetArray = WndTask:Split(target,"=")
            local subTargetArray = WndTask:Split(targetArray[1],"*")
            if "tgdrfb" == subTargetArray[1] then
                local FBMapID = subTargetArray[2]
                WZLog("CellTaskRewards::onBtnClick==>"..FBMapID)
                GlobalGame.g_subMissionID = FBMapID
            end
			GlobalGame.g_tSysConfig.cartonTab = self.m_nSubID-1 
			JumpByUIId(self.m_nMainID, self.m_nSubID)
		elseif jumpData.uiName == "ScenePet" then
			local index = 4
			local isMove = true
        	if GlobalGame.g_bIfInTeaching == true then
            	index = 2
				isMove = false
        	end
        	CheckLuaLoad(LUAFILES_BLOCK_COMMON)
        	CheckLuaLoad(Chat_Channel_Pet)
        	ScenePet:showPageConCenterPos(index,isMove)
            --发送退出房间协议
            SceneRoom:onBackSceneCallback(true)
            SceneBossRoom:onBackScene(true)

		else
			JumpByUIId(self.m_nMainID, self.m_nSubID)
		end
	elseif self.m_nTaskID > -1 then
		--WZLog("send protocol data to client by main task commit")
		local _loadingId = MsgBoxManager:showLoadingBox(nil,WndTask,nil,nil,nil)
		WndTask:setLoadingId(_loadingId)
		ProtocolProcessorWndTask:send_TASK_CommitTask(self.m_nTaskID,self.m_nTaskType)
	end

end

--@breif    设置任务类型
function CellTaskRewards:setTaskType( nTaskType )
    self.m_nTaskType = nTaskType
end


--@brief 	设置任务奖励
--@param 	tTaskRewards:任务奖励
function CellTaskRewards:setTaskRewards(tTaskRewards,quality,nItemId)
    if #tTaskRewards < self.m_nCacheItemCount then
        local i = self.m_nCacheItemCount
        while i>#tTaskRewards do
            local conItem = GetElement(self.m_root, "conItem"..i.."_CellTaskRewards", WZUIContainer)
            conItem:removeAllChildrenWithCleanup(true)
            i = i -1
        end
    end
	for i,v in pairs(tTaskRewards) do
        local tData = {}
		local conItem = GetElement(self.m_root, "conItem"..i.."_CellTaskRewards", WZUIContainer)
		--[[local itemElement, tItemLuaObj = CellTaskRewardItem:createElement()
        tItemLuaObj:setparentelement(conItem:getParent())
        tItemLuaObj:setQuality(quality[i])
		tItemLuaObj:setItemData(v[1], v[2], v[3],nItemId[i])
		conItem:addChild(itemElement)]]
        

        local key = "id_"..nItemId[i]
        local itemInfo = {id = nItemId[i], name=ShopItems[key].name,icon=ShopItems[key].icon,lastTime=v[3],quality=ShopItems[key].quality} 

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
    self.m_nCacheItemCount = #tTaskRewards
end

--@brief    其它Item点击回调
function CellTaskRewards:onOthersClick(luaTable,tag,tData)
    if tData == nil then
       return
    end
    local tagindex = tag+1
    --local conItem = GetElement(self.m_root, "conItem"..tagindex.."_CellTaskRewards", WZUIContainer)
    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(luaTable.m_root,self.m_root,1,tData,false)

end

--@brief 	设置按钮文本
--@param 	sText:要显示的按钮文本
function CellTaskRewards:setBtnText(sText)
	GetElement(self.m_root, "txtBtnText_CellTaskRewards", WZUILabelTTF):setText(sText)
end

--@brief 	设置按钮跳转界面ID
--@param 	nMainID:界面主ID
--@param 	nSubID:界面子ID
function CellTaskRewards:setBtnJumpID(nMainID, nSubID)
	self.m_nMainID = nMainID
	self.m_nSubID = nSubID
    local btnTask_CellTaskRewards = GetElement(self.m_root,"btnTask_CellTaskRewards",WZUIButton)
    if btnTask_CellTaskRewards ~= nil then
        if 0==nMainID and 0 == nSubID then
            btnTask_CellTaskRewards:setTouchEnable(false)
            --btnTask_CellTaskRewards:setVisible(false)
        else
            --btnTask_CellTaskRewards:setVisible(true)
            btnTask_CellTaskRewards:setTouchEnable(true)
        end
    end
end

--@brief 	设置任务ID
--@param 	nTaskID:界面主ID
function CellTaskRewards:setTaskID(nTaskID)
	self.m_nTaskID = nTaskID
end

function CellTaskRewards:setCartorNeedId( NID )
    self.CartorNeedId = NID
end

--@brief    界面适配
function CellTaskRewards:setSceneAdapet( bIsNeedAdapet,bTaskState )
    local btnTask_CellTaskRewards = GetElement(self.m_root,"btnTask_CellTaskRewards",WZUIButton)
    if btnTask_CellTaskRewards ~=nil then
        btnTask_CellTaskRewards:setRelativePosition(GlobalMethod:ccp(0.9,0.03))
    end
    local imgbtnTask_1_completed = GetElement(self.m_root,"imgbtnTask_1_completed",WZUI9Image)
    local imgbtnTask_2_completed = GetElement(self.m_root,"imgbtnTask_2_completed",WZUI9Image)
    local imgbtnTask_3_completed = GetElement(self.m_root,"imgbtnTask_3_completed",WZUI9Image)
    if bIsNeedAdapet then
        if bTaskState then --任务完成状态
            if imgbtnTask_1_completed ~= nil then
                imgbtnTask_1_completed:setRelativeSize(GlobalMethod:CCSize(2.05,1))
            end

            if imgbtnTask_2_completed ~= nil then
                imgbtnTask_2_completed:setRelativeSize(GlobalMethod:CCSize(2.05,1))
            end
        else
            --WZLog("tttttttttttttttttttttttttttttt"..self.m_nMainID..self.m_nSubID)
            if imgbtnTask_1_completed ~= nil then
                imgbtnTask_1_completed:setRelativeSize(GlobalMethod:CCSize(1,1))
                
            end
            if 0==self.m_nMainID and 0 == self.m_nSubID then
                imgbtnTask_3_completed:setRelativeSize(GlobalMethod:CCSize(2.05,1))
            end
            if imgbtnTask_2_completed ~= nil then
                
                imgbtnTask_2_completed:setRelativeSize(GlobalMethod:CCSize(1,1))
                
            end
        end
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	设置界面上的静态文本
function CellTaskRewards:_setStaticText()
	GetElement(self.m_root, "txtTitle_CellTaskRewards", WZUILabelTTF):setText(LocalStrings.TASK_REWARD)
end

-------------------------------------私有方法模块End----------------------------------------



-------------------------------------语言适配模块Begin----------------------------------------

--@brief	英文适配函数
--@note		英文适配函数
function CellTaskRewards:_adaptLanguage_en()
    
end

-------------------------------------语言适配模块End----------------------------------------



