--WndBottomMenu.lua
--@brief	WndBottomMenu的UI模块
--@date		2013/12/10
--@author	xiaoyu_wu
--@modify   qixiang_xie
--@note		底部菜单模块


-------------------------------------公有方法模块Begin--------------------------------------
--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note	在这里做场景进入前的准备工作
function WndBottomMenu:onEnter(element)
    WZLog("WndBottomMenu:onEnter",self.g_tMailCount)
	self.m_root = element
	--描边字多语言版本文本
	self:_moreLanguageForStroke()
	local txtBack = element:getChildElement("txtBack_WndBottomMenu")
	if txtBack ~= nil then
		txtBack = WZUILabelTTF:luaTo(txtBack)
		txtBack:setText(LocalStrings.BACK)
	end  
    local tBtnsInfo = GlobalGame:getBtnInfoByType(ISLAND_BTNTYPE_BOTTOM)
    self:setBtnsInfo(tBtnsInfo) 
    --ProtocolProcessorWndBottomMenu:regAll()
    --ProtocolProcessorWndBottomMenu:send_TASK_GetTaskStatus()
    --ProtocolProcessorWndBottomMenu:send_MAIL_LoginCheckMail()
    --self:setMailCount(true, GlobalGame.g_nMailCount)
    self:setTaskCount(true, GlobalGame.g_nTaskCount)
    --self:setChatCount(true, GlobalGame.g_nChatCount)  --聊天系统
    AdaptLanguage(self)
    -- element:enableSchedule("scheduleUpdateTaskAndMailCount", 2)
    GetElement(self.m_root, "txtChatCount_WndBottomMenu", WZUILabelTTF):enableSchedule("refreshChatNum",0.1)
end

--@brief    设置未读聊天信息数目
function WndBottomMenu:refreshChatNum()
           --WZLog("WndBottomMenu:refreshChatNum()")
           local conChatCount = self.m_root:getChildElement("conChatCount_WndBottomMenu")
           local txtChatCount = GetElement(self.m_root, "txtChatCount_WndBottomMenu", WZUILabelTTF)
           if GlobalGame.g_nPrivateNum > 0 then
                        conChatCount:setVisible(true)
                       if GlobalGame.g_nPrivateNum > 99 then --当聊天数目大于等于100时，只显示数字99
                            GlobalGame.g_nPrivateNum = 99
                       end
                       txtChatCount:setText(tostring(GlobalGame.g_nPrivateNum))
           else
                       conChatCount:setVisible(false)
           end
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndBottomMenu:onExit(element)
    WZLog("WndBottomMenu:onExit", tostring(g_bIsPushScene), tostring(g_bIsPopScene))
    if g_bIsPushScene == true then
        return
    end
    element:disableSchedule()
    --ProtocolProcessorWndBottomMenu:unregAll()
	self:_unInit()
    Teach:isStartTeach("WndBottomMenu:onExit")
end

--@brief	点击聊天按钮后的响应方法
--@param	element:按钮的UI节点引用
--@note	在这里做相应的按钮相应事件
function WndBottomMenu:onClickChat(element)
            WZLog("WndBottomMenu:onClickChat")
    SoundManager:playEffectSound(SoundDefine.E_S_OPEN_WIN)
    DataUUtil("OL_Island_Chat","")
    if self.m_root == nil then
    	return    
    end
        WndCurrentChat:wndCurChatVisible(false)
        WndChat:showChatWindow()
end

--@brief    点击卡牌按钮后的响应方法
--@param    element:按钮的UI节点引用
--@note 在这里做相应的按钮相应事件
function WndBottomMenu:onClickCard(element)
    WZLog("WndBottomMenu:onClickChat")
    SoundManager:playEffectSound(SoundDefine.E_S_OPEN_WIN)
    if true then
        MsgBoxManager:showTipBox("此功能暂未开放")
        return
    end
end

--@brief	点击充值按钮后的响应方法
--@param	element:按钮的UI节点引用
--@note	在这里做相应的按钮相应事件
function WndBottomMenu:onClickPay(element)
	WZLog("WndBottomMenu:onClickPay")
    if true then
        MsgBoxManager:showTipBox("此功能暂未开放")
        return
    end
    DataUUtil("OL_Island_Tick","")
	SoundManager:playEffectSound(SoundDefine.E_S_OPEN_WIN)
	if self.m_root == nil then
		return
	end

    --百度多酷SDK专用，用来屏蔽多次点击充值，多次弹出多酷SDK充值界面
    --if ProjConfig.CHANNEL_ID == USE_BD_SDK then
    --    if not self.m_bCanRechargeDuoku then
    --        return
    --    end
    --    self.m_bCanRechargeDuoku = false
    --end

    CheckLuaLoad(LUAFILES_BLOCK_COMMON)  
    PassportSdkManager:gotoPaymentPage()

	--if ProjConfig.PAYMENT == "WndRechargeAndroid" then
	--	local Recharge = WndRechargeAndroid:createElement()
	--	WindowManager:addWindow( Recharge , WndRechargeAndroid)
	--else
	--	PassportSdkManager:gotoPaymentPage()
	--end
end

--@brief	点击商城按钮后的响应方法
--@param	element:按钮的UI节点引用
--@note	在这里做相应的按钮相应事件
function WndBottomMenu:onClickShop(element)
	WZLog("WndBottomMenu:onClickShop")
    DataUUtil("OL_Island_Shop","")
	SoundManager:playEffectSound(SoundDefine.E_S_OPEN_WIN)
	if self.m_root == nil then
		return
	end
    CheckLuaLoad(LUAFILES_BLOCK_COMMON)
    CheckLuaLoad(Chat_CHannel_Shop)
	local wndShop = WndShop:createElement()
    WindowManager:addWindow(wndShop,WndShop,false)

end

--@brief	点击主角按钮后的响应方法
--@param	element:按钮的UI节点引用
--@note	在这里做相应的按钮相应事件
function WndBottomMenu:onClickPlayer(element)
    WZLog("WndBottomMenu:onClickPlayer")
    DataUUtil("OL_Island_Item","")
    SoundManager:playEffectSound(SoundDefine.E_S_OPEN_WIN)
    if self.m_root == nil then
    	return
    end
    CheckLuaLoad(LUAFILES_BLOCK_COMMON)
    CheckLuaLoad(Chat_CHannel_PlayerItem)
    WndBag:showBag()
    --WndBag:setCloseButtonCallback(self.m_lpWndPlayerCloseCallback, self.m_tCallBackLuaObjMap[self.m_lpWndPlayerCloseCallback])

end

--@brief	点击好友按钮后的响应方法
--@param	element:按钮的UI节点引用
--@note	在这里做相应的按钮相应事件
function WndBottomMenu:onClickFriend(element)
    WZLog("WndBottomMenu:onClickFriend")
    DataUUtil("OL_Island_Friend","")
    SoundManager:playEffectSound(SoundDefine.E_S_OPEN_WIN)	
    --[[
	if self.m_root == nil then
		return
	end
	local wndFriend = WndFriend:createElement()
	WindowManager:addWindow(wndFriend,WndFriend)	
	
	
	local nearbyFriend = WndNearbyFriend:createElement()
	if nearbyFriend then
		WindowManager:addWindow( nearbyFriend , WndNearbyFriend)
	end
	WndRole:showInterface(GlobalGame.g_tPlayerInfo.nPlayerId)
	--]]
	
    CheckLuaLoad(LUAFILES_BLOCK_COMMON)
    CheckLuaLoad(Chat_Channel_Friend)
    CheckLuaLoad(Chat_CHannel_Mail)
    local nearbyFriend = WndNearbyFriend:createElement()
    if nearbyFriend then
    	WindowManager:addWindow( nearbyFriend , WndNearbyFriend)
    end
end

--@brief	点击邮件按钮后的响应方法
--@param	element:按钮的UI节点引用
--@note	在这里做相应的按钮相应事件
function WndBottomMenu:onClickMail(element)
    WZLog("WndBottomMenu:onClickMail")
    DataUUtil("OL_Island_Mail","")
    SoundManager:playEffectSound(SoundDefine.E_S_OPEN_WIN)
    if self.m_root == nil then
    	return
    end
    CheckLuaLoad(LUAFILES_BLOCK_COMMON)
    CheckLuaLoad(Chat_CHannel_Mail)
    local wndMailElement = WndMail:createElement()
    --self.m_root:getRootElement():addChild(wndMail)
    WindowManager:addWindow(wndMailElement, WndMail)   
end

--@brief	点击任务按钮后的响应方法
--@param	element:按钮的UI节点引用
--@note	在这里做相应的按钮相应事件
function WndBottomMenu:onClickTask(element)
    WZLog("WndBottomMenu:onClickTask")
    do
        local sceneIsland = SceneIsland:createElement()
        replaceScene(sceneIsland)
        return
    end
    SoundManager:playEffectSound(SoundDefine.E_S_OPEN_WIN)
    if self.m_root == nil then
    	return
    end

    CheckLuaLoad(LUAFILES_BLOCK_COMMON)
    CheckLuaLoad(Chat_CHannel_Task)
    local wndTaskElement = WndTask:createElement()
    WindowManager:addWindow(wndTaskElement, WndTask)
end


--@brief    点击星魂按钮后的响应方法
--@param    element:按钮的UI节点引用
--@note 在这里做相应的按钮相应事件
function WndBottomMenu:onClickSoul(element)
    WZLog("WndBottomMenu:onClickSoul")
    WndStarSoul:openWndStarSoul()
end

--@brief    点击强化按钮后的响应方法
--@param    element:按钮的UI节点引用
--@note 在这里做相应的按钮相应事件
function WndBottomMenu:onClickStrengthen(element)
    WZLog("WndBottomMenu:onClickStrengthen")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)
    local wndStrengthen = WndStrengthen:createElement()
    if wndStrengthen ~= nil then
        WindowManager:addWindow(wndStrengthen, WndStrengthen, false)
    end
end

--@brief    点击宠物按钮后的响应方法
--@param    element:按钮的UI节点引用
--@note 在这里做相应的按钮相应事件
function WndBottomMenu:onClickPet(element)
    WZLog("WndBottomMenu:onClickPet")
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)
    DataUUtil("OL_Island_Pet","")
    local index = 4
    local isMove = true
   
    CheckLuaLoad(LUAFILES_BLOCK_COMMON)
    CheckLuaLoad(Chat_Channel_Pet)
    ScenePets:showPetsForTag(2)
    --local scenePets = ScenePets:createElement()
    --ScenePets:setShowTag(2)
    --WindowManager:addWindow(scenePets,ScenePets,false)
end

--@brief    点击坐骑按钮后的响应方法
--@param    element:按钮的UI节点引用
--@note 在这里做相应的按钮相应事件
function WndBottomMenu:onClickPersonalMount(element)
    WZLog("WndBottomMenu:onClickPersonalMount")
    local mounts = WndMounts:createElement()
    WindowManager:addWindow(mounts,WndMounts)
end

--@brief	点击返回按钮后的响应方法
--@param	element:按钮的UI节点引用
--@note	在这里做相应的按钮相应事件
function WndBottomMenu:onClickBack(element)
    WZLog("WndBottomMenu:onClickBack")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if self.m_root == nil then
    	return
    end

    if self.m_lpBackButtonCallback ~= nil then
    	local tLuaObj = self.m_tCallBackLuaObjMap[self.m_lpBackButtonCallback]
    	self.m_lpBackButtonCallback(tLuaObj)
    elseif self.m_tBackSceneLuaObj ~= nil then
    	self:goBack()
    end
end

--@brief	设置返回按钮是否可用
--@param	bEnable:是否可用的标志位
--@note		设置返回按钮是否可用
function WndBottomMenu:setBackButtonEnable(bEnable)
	if self.m_root == nil then
		WZLog("WndBottomMenu root is nil")
		return
	end
	local btnBack = self.m_root:getChildElement("btnBack_WndBottomMenu")
	if btnBack == nil then
		WZLog("WndBottomMenu btnBack is nil")
		return
	end
	btnBack:setTouchEnable(bEnable)
end

--@brief	返回上一个场景
function WndBottomMenu:goBack()
	local scene = self.m_tBackSceneLuaObj:createElement()
	replaceScene(scene)
end

--@brief	设置所有按钮是否可点击
--@param	bEnable，是否可点击
function WndBottomMenu:setAllButtonTouchEnable(bEnable)

    if true then
        return
    end
    WZLog("WndBottomMenu:setAllButtonTouchEnable")
	if self.m_root == nil then
		return
	end
	
    for i = 1, 8 do
        local con = GetElement(self.m_root, "con"..i.."_WndBottomMenu")
        local btn = con:getChildByTag(1)
        if btn then
            btn = WZUIButton:luaTo(btn)
            if btn then
                btn:setTouchEnable(bEnable)
            end
        end
    end
    local btnBack = GetElement(self.m_root, "btnBack_WndBottomMenu")
	btnBack:setTouchEnable(bEnable)
    local btnChat = GetElement(self.m_root, "btnChat_WndBottomMenu")
	btnChat:setTouchEnable(bEnable)
end

--@brief	设置聊天按钮是否可点击
--@param	bEnable，是否可点击
function WndBottomMenu:setChatButtonTouchEnable(bEnable)
	if self.m_root == nil then
		return
	end

    local btnChat = GetElement(self.m_root, "btnChat_WndBottomMenu")
	btnChat:setTouchEnable(bEnable)
end



--@brief	定时更新未读邮件和完成未提交任务数量的方法
--@param    element，绑定定时器的节点引用
--@param    delta，定时器时间间隔
function WndBottomMenu:scheduleUpdateTaskAndMailCount(element, delta)
    --重走登录过程（例如切换账号）时结束定时器
    if not GlobalGame.g_bIfLoginOk then
        self.m_root:disableSchedule()
    end
    
    ProtocolProcessorWndBottomMenu:send_TASK_GetTaskStatus()
    ProtocolProcessorWndBottomMenu:send_MAIL_LoginCheckMail()
end

--@brief	设置完成未提交的任务数量
--@note	    由协议层回调
function WndBottomMenu:setTaskCount(status, taskNum)
    -- status : true:有，false：没有
	-- taskNum : 未提交完成任务数量
    if self.m_root == nil then
        return
    end
    --local conTaskCount = self.m_root:getChildElement("conTaskCount_WndBottomMenu")
    --if conTaskCount == nil then
     --   return
    --end

    --if status and taskNum > 0 then
    --    conTaskCount:setVisible(true)
    --    if taskNum > 99 then
    --        taskNum = 99
     --   end
        --local txtTaskCount = GetElement(self.m_root, "txtTaskCount_WndBottomMenu", WZUILabelTTF)
        --txtTaskCount:setText(tostring(taskNum))
    --else
    --    conTaskCount:setVisible(false)
   -- end

    --self.m_nTaskCount = taskNum
end

--@brief	设置未读邮件数量
--@note	    由协议层回调
function WndBottomMenu:setMailCount(checkMail, mailNum)
    -- checkMail : 是否有未读邮件（true表示有，false表示没有）
	-- mailNum : 未读邮件数量
    if self.m_root == nil then
        return
    end
    local conMailCount = self.m_root:getChildElement("conMailCount_WndBottomMenu")
    if conMailCount == nil then
        return
    end
    
    if checkMail and mailNum > 0 then
        conMailCount:setVisible(true)
        if mailNum > 99 then
            mailNum = 99
        end
        local txtMailCount = GetElement(self.m_root, "txtMailCount_WndBottomMenu", WZUILabelTTF)
        txtMailCount:setText(tostring(mailNum))
    else
        conMailCount:setVisible(false)
    end
end

--@brief	设置任务弹出提示框
function WndBottomMenu:setDialogTask()
	if GlobalGame.g_tPlayerInfo.nLevel ~= nil and GlobalGame.g_tPlayerInfo.nLevel <= GlobalGame.g_nHallLevelDividingLine and GlobalGame.g_nTaskCount == 0 and
        GlobalGame.g_tPlayerInfo.nZsleve == 0 and GlobalGame.g_bIfInTeaching == false then
        local btnCommunity = GetElement(self.m_root, "btnTask_WndBottomMenu")
        _, self.m_tTaskDialogLuaObj = CellDialog:addDialog(btnCommunity, nil,LocalStrings.DIALOG_TASK_ISLAND, CellDialog.DIR_UP, -1, nil, nil, -40, 5)
		
    end
end

--@brief	移除任务弹出提示框
function WndBottomMenu:removeTask()
	if self.m_tTaskDialogLuaObj then 
		self.m_tTaskDialogLuaObj:removeDialog() 
	end
end

--@brief	人物升级后更新底部菜单
function WndBottomMenu:updateForUpgrade()
    if self.m_root == nil then
        return
    end
    
    local bUpdateFlag = false --是否更新，仅当有新功能开放时才更新
           if GlobalGame.g_tPlayerInfo.nZsleve == 0 then
                   for i,v in ipairs(self.m_tBtnsInfo) do
                               if v.buttonStatus3Level == GlobalGame.g_tPlayerInfo.nLevel then
                                    bUpdateFlag = true
                                    break
                               end
                   end
           end
    if bUpdateFlag then
        self:_update()
    end
end

-------------------------------------公有方法模块End----------------------------------------
-------------------------------------私有方法模块Begin--------------------------------------
--@brief	更新底部菜单UI界面
function WndBottomMenu:_update()
    WZLog("WndBottomMenu:_update")
    if self.m_root == nil then
        return
    end
    if self.m_tBtnsInfo == nil then
         WZLog("WndBottomMenu:_setDefaultBtnsInfo")
        self:_setDefaultBtnsInfo()
        self:_sortButton()
    end
	
    local nTag = 1
    for i,v in ipairs(self.m_tBtnsInfo) do
        if self:_checkIconButtonOpen(v) then
             WZLog("WndBottomMenu:btnId  = ",v.buttonId)
            local btn = self:_createIconButton(v.buttonId)
            
            if btn ~= nil then
                btn:setVisible(true)
                local con = GetElement(self.m_root, "con"..9-nTag.."_WndBottomMenu")
				con:removeAllChildrenWithCleanup(true)
                con:addChild(btn)
                WZLog("WndBottomMenu:btn =  , nTag = ",btn,nTag)
                if v.buttonId == ISLAND_BOTTOM_MAIL then
                    local conMailCount = WZUISystem:getInstance():createElement("conMailCount_WndBottomMenu")
                    if conMailCount ~= nil then
                        con:addChild(conMailCount)
                    end
                elseif v.buttonId == ISLAND_BOTTOM_TASK then
                    --local conTaskCount = WZUISystem:getInstance():createElement("conTaskCount_WndBottomMenu")
                    --if conTaskCount ~= nil then
                     --   con:addChild(conTaskCount)
                    --end
                end
                
                nTag = nTag + 1
                if nTag > 8 then
                    break
                end
            end
        end
    end
	--self:_setBackgroundIcon(nTag-1)
	self:_adaptLanguageEn()
end
--[[
--菜单按钮的节点名称
local tBtnName = {
    [ISLAND_BOTTOM_SHOP] = "btnShop_WndBottomMenu",
    [ISLAND_BOTTOM_SOUL] = "btnSoul_WndBottomMenu",
    [ISLAND_BOTTOM_CARD] = "btnCard_WndBottomMenu",
    [ISLAND_BOTTOM_PERSONALMOUNT] = "btnPersonalMount_WndBottomMenu",
    [ISLAND_BOTTOM_PET] = "btnPet_WndBottomMenu",
    [ISLAND_BOTTOM_STRENGTHEN] = "btnStrengthen_WndBottomMenu",
    [ISLAND_BOTTOM_BAG] = "btnPlayer_WndBottomMenu"
}
--]]
--@brief	根据按钮id创建一个按钮
--@param    nButtonId, 按钮id
--@return   #1, 按钮的节点引用
function WndBottomMenu:_createIconButton(nButtonId)
    local sBtnName = tBtnName[nButtonId]
    if sBtnName == nil then
        return
    end
    local btn = WZUISystem:getInstance():createElement(sBtnName)
    return btn
end

--@brief	检查功能按钮是否开放
--@param    tButtonInfo, 按钮信息表
--@return   #1, 是否开放
function WndBottomMenu:_checkIconButtonOpen(tButtonInfo)

    --转生过都开放
    if GlobalGame.g_tPlayerInfo.nZsleve ~= nil and GlobalGame.g_tPlayerInfo.nZsleve > 0 and  GlobalGame.g_tPlayerInfo.nZsleve < 10 then
        return true
    end
    
    if GlobalGame.g_tPlayerInfo.nLevel and tButtonInfo.buttonStatus3Level and 
        GlobalGame.g_tPlayerInfo.nLevel < tButtonInfo.buttonStatus3Level then
        return false
    else
        return true
    end
end

--描边字文本
function WndBottomMenu:_moreLanguageForStroke()
	if self.m_root == nil then
		return
	end
	--返回
	for i = 1,3 do 
		local sName = "txtBtnBack%d_WndBottomMenu"
		sName = string.format(sName,i)	
		local txtBtnBack = self.m_root:getChildElement(sName)
		if txtBtnBack then
			txtBtnBack = WZUILabelTTF:luaTo(txtBtnBack)	
			txtBtnBack:setText(LocalStrings.BACK)
		end
	end
end

--@brief	设置背景图
--@param    num, 按钮个数
function WndBottomMenu:_setBackgroundIcon(num)
	local sizeX = num*0.13+0.22
	local imgBackground = self.m_root:getChildElement("imgBackground_WndBottomMenu")
	imgBackground = WZUI9Image:luaTo(imgBackground)
	imgBackground:setRelativeSize(CCSize(sizeX,1))
end

-------------------------------------私有方法模块End----------------------------------------
