--WndDressUp.lua
--@brief	WndDressUp的UI模块
--@date		2015/06/11
--@author	zsq
--@note		更换装备窗口


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndDressUp:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)
end

function WndDressUp:onCloseClick()
	WZLog("WndDressUp:onCloseClick")
    local taskList = PrefetchCache:getSingleCopyTask()
    WZLog("WndDressUp:onCloseClick", tostring(taskList and taskList[1] and taskList[1].nId), tostring(taskList and taskList[1] and taskList[1].nTaskStatus))
    if taskList and taskList[1] and taskList[1].nId == TeachGroup1.TASK_ID_10 and taskList[1].nTaskStatus == 0 then
        return 
    end
    if self.m_tMsgData ~= nil then
        self.m_tMsgData.nStatus = MSGBOXSTATUS_DONE
    end
	if self.m_root ~= nil then
        WindowManagerAni:createDisappearAction(self.m_root,nil,self, true)
	end 
end

--@brief	检查是否按下按钮
--return 	true:表示按下按钮，false：表示不在窗口范围内
function WndDressUp:checkPoint(pt,dir)
	if self.m_root == nil or pt == nil then return end
	dir = dir or ccp(0,0)
	local bPointBtn = self:_checkBtnPoint(pt,dir)--检查是否按下在按钮下
	return (bPointBtn or false)
end

--@brief	检查是否按下在按钮下
function WndDressUp:_checkBtnPoint(pt)
	local btnName = {"btnClose_WndDressUp","btnDressUp"}
	for i=1,2 do
		local btn = GetElement(self.m_root,btnName[i],WZUIButton)
		if btn then
			local x = btn:getPositionX()
			local y = btn:getPositionY()
			local pt1 = btn:convertToNodeSpace(GlobalMethod:ccp(pt.x,pt.y))
			local btnSize = btn:getContentSize()
			if pt1.x > 0 and pt1.x < btnSize.width and pt1.y > 0 and pt1.y < btnSize.height then
				return true
			end
		end
	end
	return false
end

--@brief	加载动画
function WndDressUp:onEnterTransitionDidFinish(element)
    WindowManagerAni:createAction(self.m_root,false,"actionCallback",self)
end

function WndDressUp:actionCallback( )
    -- if WndTask.m_root and WndTask.m_tTaskList and WndTask.m_tTaskList.tMainTask and WndTask.m_tTaskList.tMainTask[1].nId == TeachGroup1.TASK_ID_10 and WndTask.m_tTaskList.tMainTask[1].nTaskStatus == 0 then
    --     TeachGroup1:startGroupLevelUp(nil, nil, true, nil, {32,5,self.m_root})
    -- end

    local isEndTeach26, step26 = TeachGroup1:isTeachFinish(26)
    local isEndTeach41, step41 = TeachGroup1:isTeachFinish(41)
    WZLog("WndDressUp:actionCallback", step26, step41)
    if isEndTeach26 ~= true and CacheCenter:getPlayerInfo().level == 10 then
        TeachGroup1:startGroupLevelUp(nil, nil, true, nil, {26,8,self.m_root})
    elseif isEndTeach41 ~= true and step41 < 5 and CacheCenter:getPlayerInfo().level == 9 and WndEquipLottery.m_root then
        TeachGroup1:startGroupLevelUp(nil, nil, true, nil, {41,4,self.m_root})
    elseif isEndTeach41 ~= true and step41 < 6 and CacheCenter:getPlayerInfo().level == 9 and WndEquipLottery.m_root then
        TeachGroup1:startGroupLevelUp(nil, nil, true, nil, {41,6,self.m_root})
    end

    self:updateInfo()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndDressUp:onExit(element)
    local fighting = self.m_tData.nRiseFighting
	self:_unInit()
    GlobalGame.m_bIsShowEquipDressUp = nil

    -- local taskList = PrefetchCache:getSingleCopyTask()
    -- if WndSingleCopy.m_root and taskList and taskList[1] and taskList[1].nId == TeachGroup1.TASK_ID_10 and taskList[1].nTaskStatus == 0 then
    --     TeachGroup1:endTeachStep({32,3})
    --     TeachGroup1:startGroup({32,4,WndSingleCopy.m_root})
    -- end

    local isEndTeach26, step26 = TeachGroup1:isTeachFinish(26)
    local isEndTeach41, step41 = TeachGroup1:isTeachFinish(41)
    WZLog("WndDressUp:onExit",isEndTeach26, step26,isEndTeach41, step41)
    if isEndTeach26 ~= true and step26 > 0 and CacheCenter:getPlayerInfo().level == 10 then
        TeachGroup1:endTeachStep({26,8})
        if GlobalGame.g_tWndBottomBarObj then
            TeachGroup1:startGroupLevelUp(false, false, true, nil, {26,9,GlobalGame.g_tWndBottomBarObj.m_root})
            return
        end
    elseif isEndTeach41 ~= true and step41 > 0 and step41 < 5 and CacheCenter:getPlayerInfo().level == 9 and WndEquipLottery.m_root then
        TeachGroup1:endTeachStep({41,4})
        PostPlayerEvent:postEvent(PostPlayerEvent.event_fiveLvDressup)
    elseif isEndTeach41 ~= true and step41 > 0 and step41 < 6 and CacheCenter:getPlayerInfo().level == 9 and WndEquipLottery.m_root then
        TeachGroup1:endTeachStep({41,6})
    elseif isEndTeach41 ~= true and CacheCenter:getPlayerInfo().level == 9 and WndEquipLottery.m_root then
        WindowManager:removeTeachShelterLayer()
    end

    local isEndTeach35, step35 = TeachGroup1:isTeachFinish(35)
    local msgCount = (MsgBoxManager.m_tHighLevelMsgList == nil and 0 or #MsgBoxManager.m_tHighLevelMsgList)
    msgCount = msgCount + (MsgBoxManager.m_tNormalLevelMsgLis == nil and 0 or #MsgBoxManager.m_tNormalLevelMsgLis)
    msgCount = msgCount + (MsgBoxManager.m_tLowLevelMsgList == nil and 0 or #MsgBoxManager.m_tLowLevelMsgList)

    -- local isEndTeach32, teachStep32 = TeachGroup1:isTeachFinish(32)
    WZLog("WndDressUp:onExit", fighting, tostring(isEndTeach35), tostring(TeachGroup1:isTaskTeachFinish(10203)), msgCount, tostring(MsgBoxManager:_getCurHighestPriorityMsg() and MsgBoxManager:_getCurHighestPriorityMsg().nStatus))
    if isEndTeach35 ~= true and TeachGroup1:isTaskTeachFinish(10203) and (msgCount <= 0 or (msgCount == 1 and MsgBoxManager:_getCurHighestPriorityMsg().nStatus == MSGBOXSTATUS_DONE)) then
        if WndSingleCopy.m_root and CacheCenter:getPlayerInfo().level <= 8 then
            TeachGroup1:startGroup({35,1,WndSingleCopy.m_root})
        end
    -- elseif fighting ~= -1 then
    --     if (isEndTeach32 ~= true and teachStep32 == 0 or isEndTeach32 == true) and (isEndTeach41 ~= true and teachStep41 == 0 or isEndTeach41 == true) and SceneCity:teach(true) ~= false then
    --         if WndRewardShow.m_root then
    --             WndRewardShow.m_bIsTeach = true
    --             WindowManager:removeWindow(WndRewardShow.m_root , WndRewardShow , true)
    --         end

    --         if WndTask.m_root then
    --             WndTask.m_bIsTeach = true
    --             WindowManager:removeWindow(WndTask.m_root , WndTask , true)
    --         end
    --     end
    end

end

--@brief	关闭按钮
function WndDressUp:onClose(element)
	WZLog("WndDressUp:onClose")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if self.m_tMsgData ~= nil then
        self.m_tMsgData.nStatus = MSGBOXSTATUS_DONE
    end
	if self.m_root ~= nil then
        WindowManagerAni:createDisappearAction(self.m_root,nil,self, true)
	end 
end

--@brief	穿上装备
function WndDressUp:onDressUp(element)
	WZLog("WndDressUp:onDressUp", self.m_tData.nRiseFighting)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	--战斗力为-1，打开礼包
	if self.m_tData.nRiseFighting == nil or self.m_tData.nRiseFighting == -1 then
		--如果已经打开开礼包窗口，先关闭
        if self.m_tData.maintype == 3 and self.m_tData.subtype == 7 then
            if WndChooseReward.m_root ~= nil then
                WindowManager:removeWindow(WndChooseReward.m_root, WndChooseReward, true)
            end
            local wndChooseReward = WndChooseReward:createElement()
            WindowManager:addWindow(wndChooseReward,WndChooseReward,nil,nil,nil,true)
            WndChooseReward:setData(self.m_tData)
        else 
    		if WndOpenChest.m_root ~= nil then
    			WindowManager:removeWindow(WndOpenChest.m_root, WndOpenChest, true)
    		end
    		local wndOpenChest = WndOpenChest:createElement()
    		WindowManager:addWindow(wndOpenChest,WndOpenChest,nil,nil,nil,true)
    		WndOpenChest:setData(self.m_tData)
        end
	else
        local level = tonumber(CacheCenter:getPlayerInfo().level)
		if level >= tonumber(self.m_tData.basicInfo.use_level) then
    		local id = WZLuaVector_int_:create()
            local transferState = WZLuaVector_int_:create()
            local tEquipList = {}
			id:push(self.m_tData.playerItemId)
            transferState:push(0)
            table.insert(tEquipList, CopyTable(self.m_tData))
            if self.m_tData.basicInfo.main_type == 4 then 
                WndWorldBoss:showWnd(tEquipList, id)
            else
			    ProtocolProcessorRecycling:send_PLAYERITEM_ChangeEquipment(id, transferState)
            end

            local summonType = WndEquipmentLottery:getSummonTimeType()
            if summonType and level == 9 then
                if summonType == 1 then
                    PostPlayerEvent:postEvent(PostPlayerEvent.event_nineLvClickDressup)
                elseif summonType == 2 then
                    PostPlayerEvent:postEvent(PostPlayerEvent.event_nineLvClickDressup2)
                end
            end
		else
			MsgBoxManager:showTipBox("等级不足,无法装备") 
		end
	end


    if self.m_tMsgData ~= nil then
        self.m_tMsgData.nStatus = MSGBOXSTATUS_DONE
    end

	if self.m_root ~= nil then 
		WindowManagerAni:createDisappearAction(self.m_root,nil,self, true)
	end 
end

--@brief    刷新界面信息
function WndDressUp:updateInfo()
    -- body
    local tData = self.m_tData
    --设置icon
    local con = GetElement(self.m_root, "conIcon_WndDressUp", WZUIContainer)

    local celElement,tLuaObj = CellGoodItem:createElement()
    local itemInfo = {name=tData.basicInfo.name,icon=tData.basicInfo.icon,lastTime=tData.lastNum,lastNum=tData.lastNum,quality=tData.basicInfo.quality,basicInfo=CopyTable(tData.basicInfo)}
    if celElement ~= nil then 
        celElement = WZUIContainer:luaTo(celElement)
        tLuaObj:setCellGoodItem(itemInfo, 8)
        con:addChild(celElement)
    end

    --设置名字
    GetElement(self.m_root, "txtName_WndDressUp", WZUILabelTTF):setText(tData.basicInfo.name)
    GetElement(self.m_root, "txtName_WndDressUp", WZUILabelTTF):setColor(QUALITYCOLOR[tData.basicInfo.quality])
    GetElement(self.m_root, "txtBtnCancel_WndDressUp", WZUILabelTTF):setText(LocalStrings.CANCEL)
    --右边按钮默认
    GetElement(self.m_root, "txtBtnName1_WndDressUp", WZUILabelTTF):setText(LocalStrings.USE)
    --设置战斗力
    WZLog("********* WndDressUp:updateInfo *******", Serialize(tData))
    if tData.nRiseFighting == nil or tData.nRiseFighting == -1 then
        GetElement(self.m_root, "txtFightAtlas_WndDressUp", WZUILabelAtlasFont):setVisible(false)
        GetElement(self.m_root, "imgFight", WZUIImage):setVisible(false)
        GetElement(self.m_root, "txtBtnName1_WndDressUp", WZUILabelTTF):setText(LocalStrings.USE)
    else
        GetElement(self.m_root, "txtFightAtlas_WndDressUp", WZUILabelAtlasFont):setVisible(true)
        GetElement(self.m_root, "imgFight", WZUIImage):setVisible(true)
        GetElement(self.m_root, "txtBtnName1_WndDressUp", WZUILabelTTF):setText(LocalStrings.WEAR)
        GetElement(self.m_root, "txtFightAtlas_WndDressUp", WZUILabelAtlasFont):setText(tData.nRiseFighting)
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	获得新装备时显示装备物品窗口
--@param    tData:数据
function WndDressUp:show(tMsg)
	if self.m_root ~= nil then
		return
	end
	--衣橱界面不弹
	if Wndwardrobe.m_root ~= nil then return end
    local tData = nil
    if tMsg == nil then return end
    tData = tMsg.tData
    --大于4级才弹
	if CacheCenter:getPlayerInfo() == nil then return end
    if CacheCenter.m_tPlayerInfo.level <= 4 then
        if tMsg ~= nil then tMsg.nStatus = MSGBOXSTATUS_DONE end
        return
    end
	--礼包使用完不弹
	local id = tData.basicInfo.id
	WZLog("礼包使用完不弹", CacheCenter:getPlayerItemCountById(id))
	if CacheCenter:getPlayerItemCountById(id) == 0 then
        if tMsg ~= nil then tMsg.nStatus = MSGBOXSTATUS_DONE end
		return 
	end
	if self.m_root == nil then
		local Wnd = WndDressUp:createElement()
        GetElement(Wnd, "conDressUp_WndDressUp", WZUIContainer):setShowAll(true)

        self.m_tMsgData = tMsg
        self.m_tData = tData

        Wnd:setZOrder(1000)
	    WindowManager:addWindow(Wnd , WndDressUp, nil, nil, true)
	end
end

--@brief    用于调试
-- function WndDressUp:testShow()
--     --body
--     WZLog("************* WndDressUp:testShow *************** ")
--     local tData = {lastTime = -1, lastNum = -1, basicInfo = GDatatab_item["id_3009"]}
--     self:show(tData, 987)
-- end


-------------------------------------私有方法模块End----------------------------------------
-------------------------------------------语言适配Begin---------------------------------
function WndDressUp:_adaptLanguage_pt(  )
    local txtName = GetElement(self.m_root,"txtName_WndDressUp",WZUILabelTTF)
    txtName:setFontSize(16)
    txtName:setDimensions(GlobalMethod:CCSize(240))
end

function WndDressUp:_adaptLanguage_es(  )
    local txtName = GetElement(self.m_root,"txtName_WndDressUp",WZUILabelTTF)
    txtName:setFontSize(16)
    txtName:setDimensions(GlobalMethod:CCSize(240))
end

function WndDressUp:_adaptLanguage_en(  )
    local txtName = GetElement(self.m_root,"txtName_WndDressUp",WZUILabelTTF)
    txtName:setFontSize(16)
    txtName:setDimensions(GlobalMethod:CCSize(240))
end

function WndDressUp:_adaptLanguage_tr(  )
    local txtName = GetElement(self.m_root,"txtName_WndDressUp",WZUILabelTTF)
    txtName:setFontSize(16)
    txtName:setDimensions(GlobalMethod:CCSize(240))
end

function WndDressUp:_adaptLanguage_vn(  )
    local txtName = GetElement(self.m_root,"txtName_WndDressUp",WZUILabelTTF)
    txtName:setFontSize(16)
    txtName:setDimensions(GlobalMethod:CCSize(240))
end

function WndDressUp:_adaptLanguage_ug(  )
    local txtBtnCancel = GetElement(self.m_root,"txtBtnCancel_WndDressUp",WZUILabelTTF)
    txtBtnCancel:setScale(0.8)
    txtBtnCancel:setDimensions(GlobalMethod:CCSize(130))
    local txtBtnName1 = GetElement(self.m_root,"txtBtnName1_WndDressUp",WZUILabelTTF)
    txtBtnName1:setScale(0.8)
    txtBtnName1:setDimensions(GlobalMethod:CCSize(130))
end
---------------------------------------------语言适配End-----------------------------------