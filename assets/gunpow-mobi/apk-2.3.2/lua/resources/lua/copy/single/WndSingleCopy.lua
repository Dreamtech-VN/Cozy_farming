--WndSingleCopy.lua
--@brief	WndSingleCopy的UI模块
--@date		2015/04/09
--@author	xiaoyu_wu
--@modify   qixiang_xie
--@note		单人副本


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndSingleCopy:onEnter(element)
    WZLog("WndSingleCopy:onEnter")
	self.m_root = element
    ProtocolProcessorSingleMap:regAll()

    WndCurrentChat:addWndCurrentChatToCurScene(self.m_root:getLuaObjectName(),self.m_root)
    ChangeChatChannel(Chat_Channel_Single_Copy_Hall)
    
    --self.m_nLoadingId = MsgBoxManager:showLoadingBox()
    CacheCenter:registerUpatePlayerInfoObserver(self)--注册人物
    ProtocolProcessorSingleMap:send_MAP_GetLandlordData()
    self:register()
    self:teachOnRefresh()
    self:_setDifCheckBox()
    self:_initData()
    self:_preloadImg()
    self:_initUI()
    AdaptLanguage(self)
end

--@brief    
function WndSingleCopy:afterProtocolCallBack()
    -- body
    --SoundManager:playBgMusic(SoundDefine.E_MUSIC_HALL)
    --SoundManager:stopBgMusic()
    --小岛按钮
    local conCnt = GetElement(self.m_root,"conCnt_WndSingleCopy",WZUIContainer)
    self:setIslandBtnVisible(conCnt)

    WndGangsterInn:show()
    
    self:updateTask()
end

function WndSingleCopy:register()
    GlobalGame:getGameEventDispathcer():Add(bottomMeneEvent.WndBottomMeneEvent_HonorPointCountDown,self._onWndCopyEntryInfoData,self)
end
function WndSingleCopy:unregister()
    GlobalGame:getGameEventDispathcer():Remove(bottomMeneEvent.WndBottomMeneEvent_HonorPointCountDown,self._onWndCopyEntryInfoData,self)
end

function WndSingleCopy:_onWndCopyEntryInfoData(honourPoint, restoreTime, serverTime)
    local _, score = GlobalMethod:HonorPointStatus(5)
    if tonumber(honourPoint) >= score then
        if CheckButtonOpen(ISLAND_BUILDING_BOSSMAP) then
            SceneCopy:showScene(2, nil, nil,true)
            WindowManager:removeWindow(self.m_root, self, true)
        end
    else
        local status, score = GlobalMethod:HonorPointStatus(5)
        if status == false then
            WndHonorPoint:showInterface(score, honourPoint, restoreTime, serverTime)
        end
    end
end
--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndSingleCopy:onExit(element)
    g_SingleOrTeamMap = 1
    CacheCenter:unregisterUpatePlayerInfoObserver(self)--注册人物
    -- SoundManager:playBgMusic(SoundDefine.E_MUSIC_HALL)

    local btnTaskCommit = GetElement(self.m_root,"btnTaskCommit_WndSingleCopy",WZUIButton)
    if btnTaskCommit then 
        btnTaskCommit:disableSchedule()
    end
    self:unregister()
	self:_unInit()
end

--@brief 教学
function WndSingleCopy:teachStart(tag)
        local isEndTeach1, step1 = TeachGroup1:isTeachFinish(1)
        local isEndTeach3, step3 = TeachGroup1:isTeachFinish(3)
        local isEndTeach6, step6 = TeachGroup1:isTeachFinish(6)
        local isEndTeach5, step5 = TeachGroup1:isTeachFinish(5)
        local isEndTeach7, step7 = TeachGroup1:isTeachFinish(7)
        local isEndTeach8, step8 = TeachGroup1:isTeachFinish(8)
        local isEndTeach9, step9 = TeachGroup1:isTeachFinish(9)
        local isEndTeach29, step29 = TeachGroup1:isTeachFinish(29)
        local isEndTeach31, step31 = TeachGroup1:isTeachFinish(31)
        local isEndTeach32, step32 = TeachGroup1:isTeachFinish(32)
        local isEndTeach33, step33 = TeachGroup1:isTeachFinish(33)
        local isEndTeach34, step34 = TeachGroup1:isTeachFinish(34)
        local isEndTeach35, step35 = TeachGroup1:isTeachFinish(35)
        local isEndTeach36, step36 = TeachGroup1:isTeachFinish(36)
        local isEndTeach39, step39 = TeachGroup1:isTeachFinish(39)
        local isEndTeach40, step40 = TeachGroup1:isTeachFinish(40)

        local conDifSchedule = GetElement(self.m_root, "conDifSchedule_WndSingleCopy", WZUIContainer)
        local level = CacheCenter:getPlayerInfo().level
        tag = tag or self.m_nCurPageIndex
        WZLog("WndSingleCopy:teachStart one", TeachGroup1.STEP, isEndTeach9, step9, isEndTeach33, isEndTeach32, step32, TeachGroup1:isTaskTeachFinish(10201), tostring(MsgBoxManager:_getCurHighestPriorityMsg()))
        local isTeach = true
        if isEndTeach29 ~= true and step29 > 0 and self.m_nCopyType == 2 then
            isTeach = TeachGroup1:startGroup({29,5,WndSingleCopy.m_oCurPage})
        elseif isEndTeach29 ~= true and step29 > 0 and self.m_nCopyType ~= 2 and conDifSchedule and conDifSchedule:isVisible() == true then
            isTeach = TeachGroup1:startGroup({29,4,WndSingleCopy.m_root})
        elseif isEndTeach29 ~= true and step29 > 0 and self.m_nCopyType ~= 2 and conDifSchedule and conDifSchedule:isVisible() == false then
            isTeach = TeachGroup1:startGroup({29,3,WndSingleCopy.m_root})
        elseif isEndTeach40 ~= true and TeachGroup1:isTaskTeachFinish(10206) and level == 8 then
            isTeach = TeachGroup1:startGroup({40,1,self.m_root})
        elseif isEndTeach39 ~= true and TeachGroup1:isTaskTeachFinish(10205) and level == 8 then
            isTeach = TeachGroup1:startGroup({39,1,self.m_root})
        elseif isEndTeach36 ~= true and TeachGroup1:isTaskTeachFinish(10204) and level == 8 then
            isTeach = TeachGroup1:startGroup({36,1,self.m_root})
        elseif isEndTeach35 ~= true and TeachGroup1:isTaskTeachFinish(10203) and level == 8 and WndDressUp.m_root == nil and MsgBoxManager:_getCurHighestPriorityMsg() == nil  then
            isTeach = TeachGroup1:startGroup({35,1,self.m_root})
        elseif isEndTeach34 ~= true and TeachGroup1:isTaskTeachFinish(10202) and level == 8 then
            isTeach = TeachGroup1:startGroup({34,1,self.m_root})
        elseif isEndTeach33 ~= true and TeachGroup1:isTaskTeachFinish(10201) then
            isTeach = TeachGroup1:startGroup({33,1,self.m_root})
        elseif isEndTeach32 ~= true and TeachGroup1:isTaskTeachFinish(10105) and tag == 0 then
            if step32 < 2 then
                isTeach = TeachGroup1:startGroup({32,1,self.m_root})
            else
                isTeach = TeachGroup1:startGroup({32,3,self.m_root})
            end
        elseif isEndTeach31 ~= true and TeachGroup1:isTaskTeachFinish(10104) then
            isTeach = TeachGroup1:startGroup({31,1,self.m_root})
        elseif isEndTeach5 ~= true and step5 >= 8 then
            if step5 == 8 then 
                isTeach = TeachGroup1:startGroup({5, 9, WndSingleCopy.m_root})
            else
                isTeach = TeachGroup1:startGroup({5, 10, WndSingleCopy.m_root})
            end
        elseif isEndTeach7 ~= true and step7 > 0 and TeachGroup1:isTaskTeachFinish(10103) and self.m_root then
            isTeach = TeachGroup1:startGroup({7,3,WndSingleCopy.m_root})
        elseif isEndTeach7 ~= true and TeachGroup1:isTaskTeachFinish(10103) and self.m_root then
            isTeach = TeachGroup1:startGroup({7,1,self.m_root})
        elseif isEndTeach3 == true and isEndTeach6 ~= true then
            if step6 < 1 then 
                isTeach = TeachGroup1:startGroup({6,1,self.m_root})
            else
                isTeach = TeachGroup1:startGroup({6,2,self.m_root})
            end
        elseif isEndTeach7 == true and isEndTeach8 == false and TeachGroup1.STEP < 5  then
            if GlobalGame.g_tWndBottomBarObj == nil then
                isTeach = false
            end
            isTeach = TeachGroup1:startGroup({8,2, GlobalGame.g_tWndBottomBarObj.m_root})
        elseif isEndTeach7 == true and isEndTeach8 == true and isEndTeach9 ~= true and step9 < 4  then
            isTeach = TeachGroup1:startGroup({9,1,WndSingleCopy.m_root})
        elseif isEndTeach7 == true and isEndTeach8 == false and step8 > 4 then
            if step8 <= 5 then 
                isTeach = TeachGroup1:startGroup({8,6,WndSingleCopy.m_root})
            end
        elseif isEndTeach7 == true and isEndTeach9 ~= true and step9 >= 4 then
            if step9 < 5 then 
                isTeach = TeachGroup1:startGroup({9,5,WndSingleCopy.m_root})
            else
                isTeach = TeachGroup1:startGroup({9,6,WndSingleCopy.m_root})
            end
        elseif isEndTeach1 == true and isEndTeach3 == false and step3 < 4  then
            if WndTask.m_tListItem and WndTask.m_tListItem.m_root and WndTask.m_tTaskList and WndTask.m_tTaskList.tMainTask and WndTask.m_tTaskList.tMainTask[1] then
                if WndTask.m_tTaskList.tMainTask[1].nId == TeachGroup1.TASK_ID_2 and WndTask.m_tTaskList.tMainTask[1].nTaskStatus == 0 then
                    local btn = GetElement(WndTask.m_tListItem.m_root, "btnUISwitch_CellTaskListItem", WZUIButton)
                    if btn and btn:getTouchEnable() == true then
                        isTeach = TeachGroup1:startGroup({3,4,WndTask.m_tListItem.m_root})
                    end
                end
            else
                isTeach = TeachGroup1:startGroup({3,1, self.m_root})
            end
        elseif isEndTeach1 == true and isEndTeach3 == false and step3 >= 4  then
            isTeach = TeachGroup1:startGroup({3,5,WndSingleCopy.m_oCurPage})
        else
            isTeach = TeachGroup1:startGroup({1,4,self.m_oCurPage})
        end

        WZLog("WndSingleCopy:teachStart two", tostring(isTeach))
        if isTeach == false then
            WindowManager:removeTeachShelterLayer()
        end

    if isTeach == false then
        -- self:showTipForButton()
        local btnTaskCommit = GetElement(self.m_root,"btnTaskCommit_WndSingleCopy",WZUIButton)
        btnTaskCommit:enableSchedule("showTipForButton",0.1)
    end

end

--@brief 刷新教学
function WndSingleCopy:teachOnRefresh()
        local isEndTeach1, step1 = TeachGroup1:isTeachFinish(1)
        local isEndTeach3, step3 = TeachGroup1:isTeachFinish(3)
        local isEndTeach6, step6 = TeachGroup1:isTeachFinish(6)
        local isEndTeach5, step5 = TeachGroup1:isTeachFinish(5)
        local isEndTeach7, step7 = TeachGroup1:isTeachFinish(7)
        local isEndTeach8, step8 = TeachGroup1:isTeachFinish(8)
        local isEndTeach29, step29 = TeachGroup1:isTeachFinish(29)
        local isEndTeach31, step31 = TeachGroup1:isTeachFinish(31)
        local isEndTeach32, step32 = TeachGroup1:isTeachFinish(32)
        local isEndTeach33, step33 = TeachGroup1:isTeachFinish(33)
        local isEndTeach34, step34 = TeachGroup1:isTeachFinish(34)
        local isEndTeach35, step35 = TeachGroup1:isTeachFinish(35)
        local isEndTeach36, step36 = TeachGroup1:isTeachFinish(36)

        WZLog("WndSingleCopy:teachOnRefresh one", tostring(GlobalGame.m_nStoryId), isEndTeach33, step33, TeachGroup1:isTaskTeachFinish(10201), tostring(MsgBoxManager:_getCurHighestPriorityMsg()))
        local isTeach = nil
        if isEndTeach29 ~= true and step29 == 2 then
            isTeach = true
        elseif isEndTeach29 ~= true and step29 == 1 then
            isTeach = true
        elseif isEndTeach36 ~= true and CacheCenter:getPlayerInfo().level <= 8 and TeachGroup1:isTaskTeachFinish(10204) then
            isTeach = true
        elseif isEndTeach35 ~= true and CacheCenter:getPlayerInfo().level <= 8 and TeachGroup1:isTaskTeachFinish(10203) and WndDressUp.m_root == nil and MsgBoxManager:_getCurHighestPriorityMsg() == nil  then
            isTeach = true
        elseif isEndTeach34 ~= true and CacheCenter:getPlayerInfo().level <= 8 and TeachGroup1:isTaskTeachFinish(10202) then
            isTeach = true
        elseif isEndTeach33 ~= true and TeachGroup1:isTaskTeachFinish(10201) then
            isTeach = true
        elseif isEndTeach32 ~= true and TeachGroup1:isTaskTeachFinish(10105) then
            isTeach = true
        elseif isEndTeach31 ~= true and TeachGroup1:isTaskTeachFinish(10104) then
            --isTeach = true
        elseif isEndTeach7 ~= true  then
            isTeach = true
        elseif isEndTeach3 == true and isEndTeach6 ~= true then
            isTeach = true
        elseif isEndTeach7 == true and isEndTeach8 == false and TeachGroup1.STEP < 5  then
            isTeach = true
        elseif isEndTeach7 == true and isEndTeach8 == false and TeachGroup1.STEP >= 5  then
            isTeach = true
        elseif isEndTeach1 == true and isEndTeach3 == false and step3 < 4  then
            isTeach = true
        elseif isEndTeach1 == true and isEndTeach3 == false and step3 >= 4  then
            isTeach = true
        elseif isEndTeach1 ~= true then
            isTeach = true
        end

        WZLog("WndSingleCopy:teachOnRefresh two", tostring(isTeach))
        if isTeach == true then
            WindowManager:removeTeachShelterLayer()
            WindowManager:addTeachShelterLayer( 999999 )
        end
end

--@brief	点击上一关按钮时被调用的函数
--@param	element:按钮绑定的UI节点引用
function WndSingleCopy:onClickPrevious(element)
    WZLog("WndSingleCopy:onClickPrevious =",self.m_nCurPageIndex,self.m_nCurCopyIndex)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if self.m_nCurPageIndex <= self.m_nCurCopyIndex then
        if self.m_bLoadFinish then
            self:_pageTurning(self.m_nCurPageIndex-1)
        end
    else
        self:checkPageIndex(-1)
    end
end

--@brief	点击下一关按钮时被调用的函数
--@param	element:按钮绑定的UI节点引用
function WndSingleCopy:onClickNext(element)
    WZLog("WndSingleCopy:onClickNext ",self.m_nCurPageIndex,self.m_nCurCopyIndex)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if self.m_nCurPageIndex < self.m_nCurCopyIndex then
        if self.m_bLoadFinish  then
            self:_pageTurning(self.m_nCurPageIndex+1)
        end
    else
        self:checkPageIndex(1)
    end
end

--@brief	翻页时被调用的函数
--@param    nIndex:当前序号
function WndSingleCopy:onPageChanged(nIndex)
    if nIndex == nil then
        nIndex = self.m_oPageCon:getCurrentPageIndex()
    end
    if  self.m_nCurPageIndex == nIndex then
        return
    end
    WZLog("WndSingleCopy:onPageChanged = ",nIndex)

    local playerLevel = CacheCenter:getPlayerInfo().level
    self:_setCurrentPageIndex(nIndex)
    local frontDrawBoxStats = self:getFrontChapterBoxStats()
    if frontDrawBoxStats and playerLevel > 10 and false then
        local conTip1 = GetElement(self.m_root,"conTip1_WndSingleCopy",WZUIContainer)
        conTip1:setVisible(true)
    end
    local behineDrawBoxStats = self:getBehindChapterBoxStats()
    if behineDrawBoxStats and playerLevel > 10 and false then
        local conTip2 = GetElement(self.m_root,"conTip2_WndSingleCopy",WZUIContainer)
        conTip2:setVisible(true)
    end
    self:_playSoundeffect()
end

--@brief	点击关卡时的回调
--@param	tCellLevel:被点击的关卡绑定的lua对象
function WndSingleCopy:onClickLevelBack(tCellLevel)
    WZLog("WndSingleCopy:onClickLevelBack ", Serialize(tCellLevel:getData()))
    
    --判断关卡是否开启
    if tCellLevel:getState() == CellSingleCopyLevel.STATE_LOCKED then
        self:showTips(LocalStrings.LEVEL_LOCKED)
        return
    elseif tCellLevel:getState() == CellSingleCopyLevel.STATE_UNPASSEDCOMMON then
        --错误提示：通关上一个关卡才能挑战该关卡
        if self.m_nCopyType == 2 then
            self:showTips(LocalStrings.PASS_COMMON_SECTION_TIP)
        elseif self.m_nCopyType == 3 then
            self:showTips(LocalStrings.PASS_ELITE_SECTION_TIP)
        end
        return
    elseif tCellLevel:getState() == CellSingleCopyLevel.STATE_LEVELUNREACHED then
        --错误提示：等级不足
        --local sMsg = string.format(LocalStrings.LEVEL_UNREACHED, tCellLevel:getData().level)
        --MsgBoxManager:showTipBox(sMsg)
        WndFastJump:addParentRoot(tCellLevel:getData().level)
        return
    end

    if CacheCenter:getPlayerInfo().level == 1 and tCellLevel:getData().id == 10101 then 
        PostPlayerEvent:postEvent(PostPlayerEvent.event_gotoSingleCopy1_1)
    elseif CacheCenter:getPlayerInfo().level == 1 and tCellLevel:getData().id == 10102 then 
        PostPlayerEvent:postEvent(PostPlayerEvent.event_gotoSingleCopy1_2)
    end
    WndSingleCopyInfo:setJumpIsland(self.m_nJumpIsland)
    WndSingleCopyInfo:showWindow(tCellLevel:getData(),self.m_nCopyType)
end

--@brief	显示提示信息
--@param	sMsg:信息
function WndSingleCopy:showTips(sMsg)
    MsgBoxManager:showTipBox(sMsg)
end

--@brief	开始触摸翻页控件回调方法
--@param	element:触摸的节点
--@param    pt:触摸的坐标
function WndSingleCopy:onTouchBegan(element, pt)
	WZLog("WndSingleCopy:onTouchBegan")

    local playerLevel = CacheCenter:getPlayerInfo().level
    local conTip1 = GetElement(WndSingleCopy.m_root,"conTip1_WndSingleCopy",WZUIContainer)
    if conTip1 and playerLevel > 10 and false then
        conTip1:setVisible(false)
    end

    local conTip2 = GetElement(WndSingleCopy.m_root,"conTip2_WndSingleCopy",WZUIContainer)
    if conTip2 and playerLevel > 10 and false then
        conTip2:setVisible(false)
    end

    if WndDressUp.m_root ~= nil and (not WndDressUp:checkPoint(pt)) then
        WndDressUp:onCloseClick()
    end

    self:checkWhetherHideRewardDrop(pt)

    -- if ProjConfig.DEBUG == 1 then 
    --     local curPage = self:getCuPageObject()
    --     local CellCopy = GetElement(curPage, "CellCopy_WndSingleCopy", WZUIContainer)
    --     if CellCopy == nil then
    --         return
    --     end
    --     local point = CellCopy:convertToNodeSpace(pt)
    --     MsgBoxManager:showTipBox("(" .. (point.x/942) ..", " .. (point.y/558) .. ")")
    -- end
end

--@brief    检查是否按下在按钮下
function WndSingleCopy:_checkBtnPoint(pt)
    --body

    local btn = GetElement(self.m_root, "btnTemp_WndSingleCopy", WZUIButton)
    if btn then 
        local x = btn:getPositionX()
        local y = btn:getPositionY()
        local pt1 = btn:convertToNodeSpace(GlobalMethod:ccp(pt.x,pt.y))
        local btnSize = btn:getContentSize()
        if pt1.x > 0 and pt1.x < btnSize.width and pt1.y > 0 and pt1.y < btnSize.height then
            return true
        end
    end
    return false
end

--@brief    检查滑动的页数
--@param    nPageOffset,要滑动的页数,例如1表示要滑到下一个关卡，-1表示滑到上一个关卡
function WndSingleCopy:checkPageIndex(nPageOffset)
    --还未开放
    self:showTips(LocalStrings.SINGLECOPY_LOCKED_TIPS)
end

local GRAYCOLOR = GlobalMethod:ccc3(200,200,200)
local WHITECOLOR = GlobalMethod:ccc3(255,255,255)

--@brief	点击奖励箱子时的回调
--@param	element:奖励箱子绑定的UI节点
function WndSingleCopy:onClickReward(element)
    WZLog("WndSingleCopy:onClickReward")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if self.m_bGetRewardItems then
        return 
    end
    TeachGroup1:endTeachStep({7,2})
    local nIndex = element:getTag()
    
    local nStatus1 = self:_getSectionRewardStateByIndex(1)
    local nStatus2 = self:_getSectionRewardStateByIndex(2)
    local nStatus3 = self:_getSectionRewardStateByIndex(3)

    nMapGroup = self.m_tCopyData[self.m_nCurPageIndex+1][1].section
    if nStatus1 == 2 then
        ProtocolProcessorSingleMap:send_SINGLEMAP_GetSectionReward(nMapGroup,self.m_nCopyType,1)
        self.m_bGetRewardItems = true       
    elseif nStatus2 == 2 then
        if nStatus1 == 2 then
            ProtocolProcessorSingleMap:send_SINGLEMAP_GetSectionReward(nMapGroup,self.m_nCopyType,1)
            self.m_bGetRewardItems = true     
        else 
            ProtocolProcessorSingleMap:send_SINGLEMAP_GetSectionReward(nMapGroup,self.m_nCopyType,2)
            self.m_bGetRewardItems = true             
        end
    elseif nStatus3 == 2 then
        if nStatus1 == 2 then
            ProtocolProcessorSingleMap:send_SINGLEMAP_GetSectionReward(nMapGroup,self.m_nCopyType,1)
            self.m_bGetRewardItems = true   
        elseif nStatus1 ~= 2 and nStatus2 == 2 then
            ProtocolProcessorSingleMap:send_SINGLEMAP_GetSectionReward(nMapGroup,self.m_nCopyType,2)
            self.m_bGetRewardItems = true  
        elseif nStatus1 ~= 2 and nStatus2 ~= 2 then
            ProtocolProcessorSingleMap:send_SINGLEMAP_GetSectionReward(nMapGroup,self.m_nCopyType,3)
            self.m_bGetRewardItems = true  
        end
    end
    if nStatus1 ~= 2 and nStatus2 ~= 2 and nStatus3 ~= 2 then
        -- WndTips:show(element,self.m_root,3,self:getTipReward(3),GlobalMethod:ccp(160,130))
        -- WndTips.m_root:setShowAll(true)
        self:_showBoxView()
    end



   
  --   if nStatus == 0 then --未打开
  --       --self:_showRewardTips(nIndex, false)
		-- WndTips:show(element,self.m_root,3,self:getTipReward(nIndex),GlobalMethod:ccp(160,130))
		-- WndTips.m_root:setShowAll(true)
  --   elseif nStatus == 1 then --已打开
  --       --self:_showRewardTips(nIndex, true)
		-- WndTips:show(element,self.m_root,3,self:getTipReward(nIndex),GlobalMethod:ccp(160,130))
		-- WndTips.m_root:setShowAll(true)
  --   elseif nStatus == 2 then --可打开
  --       local nMapGroup = nil
  --       nMapGroup = self.m_tCopyData[self.m_nCurPageIndex+1][1].section
  --       ProtocolProcessorSingleMap:send_SINGLEMAP_GetSectionReward(nMapGroup,self.m_nCopyType,nIndex)
  --       self.m_bGetRewardItems = true
  --   end
end

--@brief    点击宝箱弹出的tips
function WndSingleCopy:_showBoxView(element)
    local nStatus1 = self:_getSectionRewardStateByIndex(1)
    local nStatus2 = self:_getSectionRewardStateByIndex(2)
    local nStatus3 = self:_getSectionRewardStateByIndex(3)
    local tRewardLocalData = self:getSectionReward()
    WZLog("箱子奖励数据",Serialize(tRewardLocalData))
    local conButtom = GetElement(self.m_root,"conRightButtom_WndSingleCopy",WZUIContainer)
    conButtom:setVisible(true)
    for i = 1,3 do
        local imgBox = GetElement(conButtom,"imgBox"..i.."_WndSingleCopy",WZUIImage)
        local nStatus = self:_getSectionRewardStateByIndex(i)
        if nStatus == 1 then
            imgBox:setFile("ui/common/commom_icon_ylq.png")
        else 
            imgBox:setFile("ui/common/commom_icon_wdc.png")
        end
        local tabReward = GetElement(conButtom,"tableRewardList"..i.."_WndSingleCopy",WZUITableContainer)
        local tReward = tRewardLocalData["reward"..i]
        -- WZLog("箱子奖励数据",Serialize(tReward))
        for j = 1, #tReward do
            local element, tNewObj = CellGoodItem:createElement()
            if element and tNewObj then 
                element:setTag(j - 1)
                tNewObj:setCellGoodLocalId(tReward[j][1], tReward[j][2], 17)
                tNewObj:setItemClickFun(self, self.onClickListItem)
                tabReward:setCellElement(element)
                element:setScale(0.7)
            end
        end
        local txtBox = GetElement(conButtom,"txtBox"..i.."_WndSingleCopy",WZUILabelTTF)
        local totalStar = tRewardLocalData["condition"..i]
        txtBox:setText(self.m_nCurStar.."/"..totalStar)
    end
end

-- 点击物品后的回调
function WndSingleCopy:onClickListItem(tItem, nTag, tData)
    WZLog("WndSingleCopy:onClickListItem")
    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(tItem.m_root,self.m_root,1,tData, false, nil,true)
end

function WndSingleCopy:checkPointInBtn(pt, index)
    WZLog("WndSingleCopy:checkPoint")
    if self.m_root == nil then return end
    -- local btn = GetElement(self.m_root, "conReward3_WndSingleCopy", WZUIContainer)
    if index == 2 then 
        btn = GetElement(self.m_root, "conRightButtom_WndSingleCopy", WZUIContainer)
    end
    if btn == nil then return false end
    local btnSize = btn:getContentSize()
    --获得btn的世界坐标
    local ptA = btn:convertToWorldSpace(GlobalMethod:ccp(0,0))
    WZLog("获得btn 世界坐标",ptA.x,ptA.y, ptA.x + btnSize.width, ptA.y + btnSize.height, pt.x, pt.y)
    WZLog("按钮大小",btnSize.width,btnSize.height)
    if (pt.x > ptA.x and pt.x < ptA.x + btnSize.width) and (pt.y > ptA.y and pt.y < ptA.y + btnSize.height) then
        WZLog("WndSingleCopy:checkPoint  true")
        return true
    else
        return false
    end 
end

function WndSingleCopy:checkWhetherHideRewardDrop(pt)
    -- body
    if self.m_root == nil then return end 

    local conRightButtom = GetElement(self.m_root, "conRightButtom_WndSingleCopy", WZUIContainer)
    local index = 1
    if conRightButtom:isVisible() then 
        index = 2
    end

    if index == 2 then 
        if not self:checkPointInBtn(pt, index) and conRightButtom:isVisible() then 
            conRightButtom:setVisible(false)
        end
    -- else
    --     local conItemDrop = GetElement(self.m_root, "conReward3_WndSingleCopy", WZUIContainer)
    --     if not self:checkPointInBtn(pt, index) and conItemDrop:isVisible() then 
    --         conItemDrop:setVisible(false)
    --     end
    end
end

--@brief  监听到玩家数据更新需要更新单人副本关卡状态
function WndSingleCopy:updatePlayerInfoData()
    WZLog("WndSingleCopy:updatePlayerInfoData")
    for i,v in ipairs(self.m_tCopyCellT) do
        local copyCellT = v:getData()
        local nState = self:_getLevelState(copyCellT)
        local nCurState = v:getState()
        if nCurState ~= nState then
            v:setState(nState)
        end
    end
end

--@brief 获取当前章节奖励信息
function WndSingleCopy:getSectionReward(curPageData)
    WZLog("WndSingleCopy:getSectionReward = ")
    local sectionId = nil
    if curPageData == nil then
        sectionId = self.m_tCopyData[self.m_nCurPageIndex+1][1].section
    else
        sectionId = curPageData.section
    end
    
    for k,v in pairs(GDatatab_section) do
        if v.section_id == sectionId and v.map_type == self.m_nCopyType then
            return v
        end
    end
    return nil
end

--@brief    获得箱子的奖励
function WndSingleCopy:getTipReward(nIndex)
    WZLog("WndSingleCopy:getTipReward = ",nIndex)
    local tRewardLocalData = self:getSectionReward()
    local totalStar = tRewardLocalData["condition"..nIndex]
    local rewardList = {}
    rewardList.icon = {}
    rewardList.num = {}
    rewardList.strartNum = self.m_nCurStar
    if self.m_nCurStar > totalStar then
        rewardList.strartNum = totalStar
    end
    rewardList.endNum = totalStar
   
    if tRewardLocalData == nil then
        WZLog("WndSingleCopy:_showRewardTips", nIndex, "get local reward data failure!")
        return
    end
    local tReward = tRewardLocalData["reward"..nIndex]
    local playerSex = CacheCenter:getPlayerInfo().sex
    for i = 1, #tReward, 2 do
        local tData = GetItemLocalData(tReward[i][1])
        if tData.main_type == 5 then
            if tData.sex == playerSex then
                table.insert(rewardList.icon,tData.icon)
                table.insert(rewardList.num,tReward[i][2])
            end
        else
            table.insert(rewardList.icon,tData.icon)
            table.insert(rewardList.num,tReward[i][2])
        end
        
    end
    
    for i = 2, #tReward, 2 do
        local tData = GetItemLocalData(tReward[i][1])
        if tData.main_type == 5 then
            if tData.sex == playerSex then
                table.insert(rewardList.icon,tData.icon)
                table.insert(rewardList.num,tReward[i][2])
            end
        else
            table.insert(rewardList.icon,tData.icon)
            table.insert(rewardList.num,tReward[i][2])
        end
    end
    --WZLog("箱子奖励",Serialize(rewardList))
    return rewardList
end

--@brief  重置当前显示的副本
--@param  pageIndex : 需要显示的副本index
function WndSingleCopy:resertCurPage(pageIndex)
    if GlobalGame.g_tWndBottomBarObj and GlobalGame.g_tWndBottomBarObj.hideExtend then
        GlobalGame.g_tWndBottomBarObj:hideExtend()
    end

    if self.m_tCellSectionSel then 
        self.m_tCellSectionSel:setSelState(false)
    end

    self.m_tCellSectionSel = self.m_tCellSectionItem[self.m_nCurCopyIndex] 
    self.m_tCellSectionSel:setSelState(true)

    if self.m_nTaskCellId ~= nil then
        self:updateCellStats(self.m_nTaskCellId)
    end
    if pageIndex then
        self:_pageTurning(pageIndex)
    else
        if self.m_nCurPageIndex ~= self.m_nCurCopyIndex-1 then
            self:_pageTurning(self.m_nCurCopyIndex-1)
        end
    end

end

--@brief  单人副本的普通模式
--@param  showAnim : 是否显示过渡动画
function WndSingleCopy:changeCommonCopy(showAnim)
    WZLog("WndSingleCopy:onClickCommonCopy")
    
    GlobalGame.g_nSingleCopyType = 1
    SceneCopy:showScene(1,nil,1)

end

--@brief  单人副本的精英模式
function WndSingleCopy:changeEliteCopy(shoAnim)
    WZLog("WndSingleCopy:onClickEliteCopy")
    if CheckButtonOpen(ELITE_COPY) then
        GlobalGame.g_nSingleCopyType = 2
        SceneCopy:showScene(1,nil,2)
    else
        local curPage = self:getCuPageObject()
        curPage:enableSchedule("scheduleChangeCopyType",0.1)
    end
end

--@brief  单人副本的恶魔模式
function WndSingleCopy:changeDevilCopy(shoAnim)
    WZLog("WndSingleCopy:changeDevilCopy")

    if CheckButtonOpen(DEVIL_COPY) then
        GlobalGame.g_nSingleCopyType = 3
        SceneCopy:showScene(1,nil,3)
    else
        local curPage = self:getCuPageObject()
        curPage:enableSchedule("scheduleChangeCopyType",0.1)
    end
end

function WndSingleCopy:scheduleChangeCopyType(element)
    element:disableSchedule()
end

-- --@brief 闪屏黑底
-- function WndSingleCopy:transitionAnim()
--     WZLog("WndSingleCopy:transitionAnim()")
--     local imgAction= GetElement(self.m_root,"imgAction_WndSingleCopy",WZUIImage)
--     imgAction:setVisible(true)
--     local fadeOut = CCFadeOut:create(1.2)
--     imgAction:runAction(fadeOut)
-- end

--@brief  选择普通模式
function WndSingleCopy:onClickCommonType(element)
    WZLog("WndSingleCopy:onClickCommonType")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

    if self.m_nCopyType == 1 then
        return
    end
    self:changeCommonCopy()
end

--@brief  选择精英模式
function WndSingleCopy:onClickEliteType(element)
    WZLog("WndSingleCopy:onClickEliteType")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

    TeachGroup1:endTeachStep({29,4})
    if self.m_nCopyType == 2 then
        return
    end
    self:changeEliteCopy()
end

--@brief  选择噩梦模式
function WndSingleCopy:onClickDevilType(element)
    WZLog("WndSingleCopy:onClickDevilType")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

    TeachGroup1:endTeachStep({29,4})
    if self.m_nCopyType == 3 then
        return
    end
    self:changeDevilCopy()
end

--@brief    点击小岛按钮回调
function WndSingleCopy:onClickIsland(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

    WndSingleCopyMyIsland:showInterface(self.m_tIslandHostId,self.m_tIslandAssistId)
end

function WndSingleCopy:onChangeSection(sectionId, tCell)
    -- body
    if sectionId == self.m_nCurPageIndex + 1 then return end 

    if self.m_tCellSectionSel then 
        self.m_tCellSectionSel:setSelState(false)
    end

    self.m_tCellSectionSel = tCell 
    self.m_tCellSectionSel:setSelState(true)
    self.m_nCurCopyIndex = sectionId 
    
    WndSingleCopy:resertCurPage(sectionId-1)
end

--@brief    点击任务按钮回调
function WndSingleCopy:onClickTask(element)
    -- body
    TeachGroup1:endTeachStep({3,2},{18,2},{20,7},{26,10},{41,8})
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)

    local isTeach = TeachGroup1.ISTEACH == true and TeachGroup1.GROUP == 42 and TeachGroup1.STEP == 1
    if CheckButtonOpen(ISLAND_RIGHT_TASK) and isTeach ~= true then
        if CacheCenter:getPlayerInfo().level == 1 then 
            PostPlayerEvent:postEvent(PostPlayerEvent.event_oneLvClickTask)
        end
        local wndTaskElement = WndTask:createElement()
        WindowManager:addWindow(wndTaskElement, WndTask,nil,nil,nil)
    end
end

--@brief    点击任务跳转或领取任务奖励
function WndSingleCopy:onClickTaskJump(element)
    -- body
    WZLog("WndSingleCopy:onClickTaskJump", type(self.m_curTaskData))
    if self.m_curTaskData == nil then 
        self:onClickTask(element)
        return 
    end

    local nTaskId = self.m_curTaskData.nId
    local taskData = GDatatab_task["id_" .. nTaskId]
    local nMainID, nSubID = -1, -1
    local tScript = taskData.script
    if tScript then 
        nMainID = tScript[1][1]
        nSubID = tScript[1][2]
    end
    WZLog("WndSingleCopy:onClickTaskJump", nMainID, nSubID)

    if nMainID <= 0 and self.m_curTaskData.nTaskStatus == TASKSTATUS_DOING then 
        self:onClickTask(element)
        return
    end
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WZLog("WndSingleCopy:onClickTaskJump", nTaskId)

    TeachGroup1.TASK_GO_ID = nTaskId

    TeachGroup1:endTeachStep({3,4},{3,5},{6,1},{6,2},{7,3},{5,9},{5,10},{8,6},{9,1},{20,8},{20,9},{9,5},{9,6},{31,1},{32,2},{32,3},{33,1},{34,1},{35,1},{36,1},{39,1},{40,1},{41,9})

    --do return end
    if self.m_curTaskData.nTaskStatus == TASKSTATUS_DOING then
        if tScript then
            if tScript[1][1] == 999 then
                PassportSdkManager:facebookTask("clickFacebook")
                return 
            elseif tScript[1][1] == 998 then
                PassportSdkManager:facebookTask("bindFacebook")
                return 
            elseif tScript[1][1] == 997 then
                if ProjConfig.LANGUAGE == "vn" then
                    DoShareVn()
                else
                    PassportSdkManager:facebookTask("shareFacebook")
                end
                return 
            elseif tScript[1][1] == 996 then
                if ProjConfig.LANGUAGE == "vn" then
                    DoLinkVn()
                else
                    PassportSdkManager:facebookTask("inviteFacebook")
                end
                return 
            end
        end
        postGotoTaskEvent(nTaskId)
        if nMainID == 27 then --公会
            SceneCommunity:onJumpToCommunity()
        elseif nMainID == 192 and CacheCenter:getPlayerInfo() and CacheCenter:getPlayerInfo().guildId == 0 then --公会副本
            SceneCommunity:onJumpToCommunity()
        elseif nMainID > -1 and nSubID > -1 then
            if nTaskId == 1120000037 then 
                WndFastGetItems.m_nShopTipItemId = nSubID
            else
                WndFastGetItems.m_nShopTipItemId = nil 
            end
            if tonumber(nMainID) == 12 then 
                local sectionId = taskData.target
                if sectionId ~= nil then
                    local strIndex = string.find(sectionId,"*")
                    local str2Index = string.find(sectionId,"=")
                    local isNull = string.find(sectionId,"-1")
                    if strIndex ~= nil and str2Index ~= nil and isNull == nil then
                        sectionId = string.sub(sectionId,strIndex+1,str2Index-1)
                        local singInfo = GDatatab_single_map["id_" .. sectionId]
                        if self.m_nCopyType ~= singInfo.map_type then 
                            JumpByUIId(nMainID, nSubID, nTaskId, 1)
                        else
                            self:setIsShowCopyLevelInfo(true)
                            WZLog("onClickTopTask ",sectionId,strIndex,str2Index)
                            self:setJumpPageIndex(sectionId)
                            if self.m_tCellSectionSel then 
                                self.m_tCellSectionSel:setSelState(false)
                            end

                            self.m_tCellSectionSel = self.m_tCellSectionItem[tonumber(singInfo.section)] 
                            self.m_tCellSectionSel:setSelState(true)
                            self.m_nJumpPageIndex = nil
                            self.m_nCurCopyIndex = tonumber(singInfo.section) 
                            
                            self:_setSectionListPos()
                            self:setDefaultMap()
                        end
                    end
                else
                    JumpByUIId(nMainID, nSubID, nTaskId, 1)
                end
            else
                JumpByUIId(nMainID, nSubID, nTaskId, 1)
            end
        end
    else 
        --背包已满提示
        if CacheCenter:getRemainAmount() <= 0 then
            MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
            return
        end
        if self:weatherInGetReward() then return end 
        
        self:setGetRewardLimit(true)
        local tData = {}
        tData.taskType = taskData.type
        tData.taskId = tostring(nTaskId)
        tData.subTaskId = "1"
        tData.taskProgr = "1_1"
        PostPlayerEvent:postEvent(PostPlayerEvent.event_task, tData)

        local tData = {}
        tData.taskType = taskData.type
        tData.taskId = tostring(nTaskId)
        tData.subTaskId = "1"
        tData.taskProgr = "1_1"
        PostPlayerEvent:postEvent(PostPlayerEvent.event_task, tData)

        WZLog("WndSingleCopy:onClickTaskJump GetReward", nTaskId)
        self.m_nLoadingId = MsgBoxManager:showLoadingBox()
        postGetTaskRewardEvent(nTaskId)
        ProtocolProcessorWndTask:send_TASK_GetTaskReward(nTaskId)
    end
end

function WndSingleCopy:updateTask()
    if self.m_root == nil then
        return
    end

    self:showCurTask()
end

function WndSingleCopy:showTipForButton(element)
    if self.m_root == nil then
        return
    end

    if WindowManager:isHaveTeachTouchLayer() ~= true then
        local playerLevel = CacheCenter:getPlayerInfo().level
        if playerLevel >= 5 and playerLevel <= 8 then
            local btn = GetElement(self.m_root,"btnTaskCommit_WndSingleCopy",WZUIButton)
            if self.m_curTaskData then
                if self.m_curTaskData.nTaskStatus == TASKSTATUS_TOSUBMIT then
                    if self.m_tButtonTipsAnim1 == nil and self.m_tButtonTipsDialog1 == nil then
                        self.m_tButtonTipsAnim1, self.m_tButtonTipsDialog1 = WindowManager:addTipForButton(btn, 0.30, GlobalMethod:ccp(100,0), 22, 2, GlobalMethod:ccp(0,50))
                    end
                    if self.m_tButtonTipsAnim2 and self.m_tButtonTipsDialog2 then
                        self.m_tButtonTipsAnim2:removeFromParentAndCleanup(true)
                        self.m_tButtonTipsDialog2:removeFromParentAndCleanup(true)
                        self.m_tButtonTipsAnim2, self.m_tButtonTipsDialog2 = nil, nil
                    end
                else
                    if self.m_tButtonTipsAnim1 and self.m_tButtonTipsDialog1 then
                        self.m_tButtonTipsAnim1:removeFromParentAndCleanup(true)
                        self.m_tButtonTipsDialog1:removeFromParentAndCleanup(true)
                        self.m_tButtonTipsAnim1, self.m_tButtonTipsDialog1 = nil, nil
                    end
                    if self.m_tButtonTipsAnim2 == nil and self.m_tButtonTipsDialog2 == nil then
                        self.m_tButtonTipsAnim2, self.m_tButtonTipsDialog2 = WindowManager:addTipForButton(btn, 0.30, GlobalMethod:ccp(100,0), 23, 2, GlobalMethod:ccp(0,50))
                    end
                end
            end
        else
            if self.m_tButtonTipsAnim1 and self.m_tButtonTipsDialog1 then
                self.m_tButtonTipsAnim1:removeFromParentAndCleanup(true)
                self.m_tButtonTipsDialog1:removeFromParentAndCleanup(true)
                self.m_tButtonTipsAnim1, self.m_tButtonTipsDialog1 = nil, nil
            end
            if self.m_tButtonTipsAnim2 and self.m_tButtonTipsDialog2 then
                self.m_tButtonTipsAnim2:removeFromParentAndCleanup(true)
                self.m_tButtonTipsDialog2:removeFromParentAndCleanup(true)
                self.m_tButtonTipsAnim2, self.m_tButtonTipsDialog2 = nil, nil
            end
        end

    else
        if self.m_tButtonTipsAnim1 and self.m_tButtonTipsDialog1 then
            self.m_tButtonTipsAnim1:removeFromParentAndCleanup(true)
            self.m_tButtonTipsDialog1:removeFromParentAndCleanup(true)
            self.m_tButtonTipsAnim1, self.m_tButtonTipsDialog1 = nil, nil
        end
        if self.m_tButtonTipsAnim2 and self.m_tButtonTipsDialog2 then
            self.m_tButtonTipsAnim2:removeFromParentAndCleanup(true)
            self.m_tButtonTipsDialog2:removeFromParentAndCleanup(true)
            self.m_tButtonTipsAnim2, self.m_tButtonTipsDialog2 = nil, nil
        end
    end

end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	初始化界面
function WndSingleCopy:_initUI()
    if self.m_root == nil then
        return
    end
    
    local conCopy = GetElement(self.m_root, "conCopy_WndSingleCopy", WZUIContainer)
    conCopy:setTouchEnable(false)
    self.m_oPageCon = conCopy

    self:_loadMapPage()
end

--@brief    创建副本页
--@param    nTag,序号
--@return   #1,副本页UI节点
function WndSingleCopy:_createCellCopy(nTag)
    WZLog("WndSingleCopy:_createCellCopy ",nTag,self.m_nCurCopyIndex)
    local GetElement = GetElement
    local cellCopy = GetElement(self.m_root, "CellCopy_WndSingleCopy", WZUIContainer)
    if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "pt" then
        GetElement(cellCopy,"txtIsland1_WndSingleCopy",WZUILabelTTF):setScale(0.6)
        GetElement(cellCopy,"txtIsland2_WndSingleCopy",WZUILabelTTF):setScale(0.6)   
    elseif ProjConfig.LANGUAGE == "ug" then
        txtTitle:setDimensions(GlobalMethod:CCSize(320,0))
        txtTitle:setScale(0.5)
    end

    assert(cellCopy, "WndSingleCopy create cellCopy failure!")
    --cellCopy:setTag(nTag-3)  --本来不用减3，但策划没有把1，2章写好，所以1，2章先不加载
    cellCopy:setVisible(true)
    
    local tCopyData = self.m_tCopyData[nTag+1]
    
    local imgCopyBg = WZUIImage:luaTo(cellCopy:getChildElement("imgCopyBg_CellCopy"))
    local mapResources = nil
    if self.m_nCopyType == 1 then
        if nTag >= 10 then
            mapResources = GDatatab_section["id_" .. nTag + 100 + 1].map_resources
        else
            mapResources = GDatatab_section["id_" .. nTag + 1].map_resources
        end
    elseif self.m_nCopyType == 2 then
        mapResources = GDatatab_section["id_" .. nTag + 11].map_resources
    elseif self.m_nCopyType == 3 then
        mapResources = GDatatab_section["id_" .. nTag + 51].map_resources
    end

    local imgCCopyRedPoints = GetElement(cellCopy,"imgCCopyRedPoints_WndSingleCopy",WZUIImage)
    local imgECopyRedPoints = GetElement(cellCopy,"imgECopyRedPoints_WndSingleCopy",WZUIImage)
    local imgDevilRedPoints = GetElement(cellCopy,"imgDevilRedPoints_WndSingleCopy",WZUIImage)
    local tempp1,tempp2 = self:isShowRedPoint()
    if tempp1 and tempp2 then
        if self.m_nCopyType == 1 then
            imgCCopyRedPoints:setVisible(false)
            imgECopyRedPoints:setVisible(true)
            imgDevilRedPoints:setVisible(true)
        elseif self.m_nCopyType == 2 then
            imgCCopyRedPoints:setVisible(true)
            imgECopyRedPoints:setVisible(false)
            imgDevilRedPoints:setVisible(true)
        elseif self.m_nCopyType == 3 then
            imgCCopyRedPoints:setVisible(true)
            imgECopyRedPoints:setVisible(true)
            imgDevilRedPoints:setVisible(false)
        end
    elseif tempp1 and not tempp2 then
        if self.m_nCopyType == 1 then
            imgCCopyRedPoints:setVisible(false)
            imgECopyRedPoints:setVisible(true)
            imgDevilRedPoints:setVisible(false)
        elseif self.m_nCopyType == 2 then
            imgCCopyRedPoints:setVisible(true)
            imgECopyRedPoints:setVisible(false)
            imgDevilRedPoints:setVisible(false)
        elseif self.m_nCopyType == 3 then
            imgCCopyRedPoints:setVisible(true)
            imgECopyRedPoints:setVisible(false)
            imgDevilRedPoints:setVisible(false)
        end
    elseif not tempp1 and tempp2 then
        if self.m_nCopyType == 1 then
            imgCCopyRedPoints:setVisible(false)
            imgECopyRedPoints:setVisible(false)
            imgDevilRedPoints:setVisible(true)
        elseif self.m_nCopyType == 2 then
            imgCCopyRedPoints:setVisible(false)
            imgECopyRedPoints:setVisible(false)
            imgDevilRedPoints:setVisible(true)
        elseif self.m_nCopyType == 3 then
            imgCCopyRedPoints:setVisible(false)
            imgECopyRedPoints:setVisible(true)
            imgDevilRedPoints:setVisible(false)
        end
    end
    if mapResources then
        imgCopyBg:setFile("ui/copy/" .. mapResources)
    end

    if nTag+1 == self.m_nCurCopyIndex then
        self.m_oCurPage = cellCopy
        if nTag == 1 then
            self.m_oPageOne = cellCopy
        end
    else
        if nTag == 1 then
            self.m_oPageOne = cellCopy
        end
    end
    local checkDif = GetElement(self.m_root,"checkDif_WndSingleCopy",WZUICheckBoxGroup)
    local playerLevel = CacheCenter:getPlayerInfo().level
    local btnInfo1 = GDatatab_button_info["id_"..2]
    local btnInfo2 = GDatatab_button_info["id_" .. 57]
    local btnInfo3 = GDatatab_button_info["id_" .. 81]
    local cbCommon = GetElement(checkDif,"checkBox1_WndSingleCopy",WZUICheckBox)
    local cbElite = GetElement(checkDif,"checkBox2_WndSingleCopy",WZUICheckBox)
    local cbDevil = GetElement(checkDif,"checkBox3_WndSingleCopy",WZUICheckBox)
    if playerLevel < btnInfo1.open_level then
        cbCommon:setVisible(false)
        cbElite:setVisible(false)
        cbDevil:setVisible(false)
    elseif playerLevel >= btnInfo1.open_level and playerLevel < btnInfo2.open_level then
        cbCommon:setVisible(true)
        cbElite:setVisible(false)
        cbDevil:setVisible(false)
    elseif playerLevel >= btnInfo2.open_level and playerLevel < btnInfo3.open_level then
        cbCommon:setVisible(true)
        cbElite:setVisible(true)
        cbDevil:setVisible(false)   
    elseif playerLevel >= btnInfo3.open_level then
        cbCommon:setVisible(true)
        cbElite:setVisible(true)
        cbDevil:setVisible(true)           
    end

    local sectionCellOrder = 20
    local countLevel = #tCopyData
    self:removeAllCell()

    for i,v in pairs(tCopyData) do
        local cellLevel = self:_createLevel(i, v, countLevel)
        if cellLevel then
            cellCopy:addChild(cellLevel)
            cellLevel:setZOrder(sectionCellOrder)
            sectionCellOrder = sectionCellOrder - 1
        end
    end

    return cellCopy
end

--@brief    创建关卡
--@param    nTag,序号
--@param    tLevelData,关卡数据表
--@return   #1,关卡UI节点
function WndSingleCopy:_createLevel(nTag, tLevelData,levelCount, state)
    local eCellLevel, tCellLevel = CellSingleCopyLevel:createElement()
    tCellLevel:setTag(nTag)
    tCellLevel:setData(tLevelData)
--    WZLog("WndSingleCopy:_createLevel-1",Serialize(tLevelData))

    local location = tLevelData.location
    local locations = SplitStringWithSeparator(location,",")

    eCellLevel:setRelativePosition(GlobalMethod:ccp(tonumber(locations[1]),tonumber(locations[2])))
    -- tCellLevel:setClickCallback(function(tCellSingleCopyLevel)
    --     self:onClickLevel(tCellSingleCopyLevel)
    -- end)
    tCellLevel:setClickCallback(self,self.onClickLevelBack)
    if self.m_nCopyType == 2 or self.m_nCopyType == 3 then
        table.insert(self.m_tCellArmList,tCellLevel)
    end
    if nTag == levelCount then
        local sectionData = self:getSectionReward(tLevelData)
        if not sectionData or sectionData.boss == nil then
            return
        end
        local stP,enP = string.find(sectionData.boss,".altas")
        tCellLevel:setArmStats(false)
        if stP ~= nil or endP ~= nil then
            local animName = string.sub(sectionData.boss, 0, stP-1)
            WZLog("WndSingleCopy:animName=",animName)
            local txtMonsterName = WZUILabelTTF:luaTo(eCellLevel:getChildElement("txtMonsterName_CellSingleCoypLevel"))
            txtMonsterName:setVisible(false)
            local FigureCon = WZUIContainer:luaTo(eCellLevel:getChildElement("conFigure_CellSingleCopyLevel"))
            FigureCon:setVisible(true)
            -- local FigureImg = WZUIImage:luaTo(eCellLevel:getChildElement("imgFigure_CellSingleCopyLevel"))
            -- FigureImg:setFile("battle/monster"..animName..".png")
            -- local conFigure = eCellLevel:getChildByTag(10086)
            -- conFigure:setVisible(true)
            local imgFigure = GetElement(FigureCon,"imgFigure_CellSingleCopyLevel",WZUIImage)
            imgFigure:setFile("battle/head/"..animName..".png")
            imgFigure:setScale(0.8)
        else
            local equipArmature = WZArmature:create()
            equipArmature:setTouchEnable(false)
            equipArmature:setArmatureName( sectionData.boss )
            equipArmature:setUseOriginSize(true)
            equipArmature:setAnchorPoint(GlobalMethod:ccp(0.5,0.0))
            equipArmature:setRelativePosition(GlobalMethod:ccp(0.5,0.35))
            equipArmature:setScale(0.4)
            local file = "battle/monster/" .. sectionData.boss .. ".xml"
            equipArmature:setArmatureFile(file)
            equipArmature:setZOrder(99)
            table.insert(self.m_tEquipArmatures, equipArmature )
            eCellLevel:addChild(equipArmature)
            local psX,psY = equipArmature:getPosition()
        end
    end
    local nState = state or self:_getLevelState(tLevelData)
   
    tCellLevel:setState(nState)
    if nState ~= 0 then
        table.insert(self.m_tCopyCellT,tCellLevel)
    end
    table.insert(self.m_tAllCopyCell,tCellLevel)
    self:showIslandOwnerRedDot()
    if self.m_nTaskCellId ~= nil then
        tCellLevel:setTaskCellId(self.m_nTaskCellId)
        local singleMapData = GDatatab_single_map["id_" .. self.m_nTaskCellId ]
        if self.m_bShowCopyLevelInfo and singleMapData and (self.m_nTaskCellId == tLevelData.id or (tLevelData.map_type == 3 and singleMapData.section == tLevelData.section and singleMapData.idgroup == tLevelData.idgroup )) then
            self.m_luaCell = tCellLevel
        end
    end
    return eCellLevel
end

--岛主红点
function WndSingleCopy:showIslandOwnerRedDot()
    local tRedDot = CacheCenter:getIslandOwnerRedData()
    if tRedDot == nil then
        return
    end
    for i=1,#self.m_tAllCopyCell do
        local bShowRed = false
        for j=1,#tRedDot do
            if self.m_tAllCopyCell[i]:getData().id == tRedDot[j] then
                bShowRed = true
                break
            end
        end
        self.m_tAllCopyCell[i]:setReDot(bShowRed)
    end
end

--@brief	设置当前页数
--@param    nIndex:页数
function WndSingleCopy:_setCurrentPageIndex(nIndex)
    WZLog("WndSingleCopy:_setCurrentPageIndex = ",nIndex)
    if self.m_root == nil or nIndex == nil then
        return
    end
    self.m_nCurPageIndex = nIndex
    
    -- self:_updateStarReward(nIndex+1) --更新星级奖励信息
    self:_updateBoxReward(nIndex+1) --更新宝箱奖励
    
end


--@brief	更新副本标题
--@param    nCurPageIndex:当前页数
function WndSingleCopy:_updateCopyTitle(nCurPageIndex, pageNode)
    WZLog("WndSingleCopy:_updateCopyTitle = ",nCurPageIndex,#self.m_tCopyData)
    -- local txtTitle = GetElement(pageNode, "txtTitle_CellCopy", WZUILabelTTF)
    -- local tLevelList = self.m_tCopyData[nCurPageIndex]
    -- if tLevelList and #tLevelList > 0 then
    --     txtTitle:setText(tLevelList[1].section_name)
    -- end
    
end

--@brief    点击模式按钮回调
function WndSingleCopy:onClickDif(element)
    --body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local conDifSchedule = GetElement(self.m_root, "conDifSchedule_WndSingleCopy", WZUIContainer)
    local bVisible = conDifSchedule:isVisible()
    conDifSchedule:setVisible(not bVisible)
    GetElement(self.m_root, "imgDifArrow_WndSingleCopy", WZUIImage):setFlipY(not bVisible)

    TeachGroup1:startGroup({29,4,WndSingleCopy.m_root})
end

-- 难度选择
function WndSingleCopy:onCheckBoxDifficult(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local tag = element:getTag()
    if self.checkTag == tag then 
        return
    else 
        self.checkTag = tag
    end 
        self:_setDifCheckBox()
        if tag == 1 then
            self:onClickCommonType()
        elseif tag == 2 then
            self:onClickEliteType()
        elseif tag == 3 then
            self:onClickDevilType()
        end
        
    GetElement(self.m_root, "conDifSchedule_WndSingleCopy", WZUIContainer):setVisible(false)
end

-- 设置选择难度的checkbox
function WndSingleCopy:_setDifCheckBox()
    WZLog("WndSingleCopy:_setDifCheckBox =",self.checkTag)
    local conCnt = GetElement(self.m_root,"conCnt_WndSingleCopy",WZUIContainer)
    local checkDif = GetElement(conCnt,"checkDif_WndSingleCopy",WZUIContainer)
    for i = 1, 4 do
        local state = self.checkTag == i and 1 or 0
        local check = WZUICheckBox:luaTo(WZUIElement:luaTo(checkDif:getChildByTag(i)))
        check:setCheckIndex(state)
    end
    --难度图标
    local tIconFile = {"ui/copy/copy_icon_jd1.png", "ui/copy/copy_icon_kn1.png", "ui/copy/copy_icon_dy1.png", "ui/copy/copy_icon_jx1.png"}
    local tDifName = {LocalStrings.NORMAL, LocalStrings.PICK, LocalStrings.E_DRAW, LocalStrings.MULCOPY_TEXT2}
    local imgDifIcon = GetElement(self.m_root, "imgDifIcon_WndSingleCopy", WZUIImage)
    if imgDifIcon then 
        imgDifIcon:setFile(tIconFile[self.checkTag])
    end
    --
    local txtDifWord = GetElement(self.m_root, "txtDifWord_WndSingleCopy", WZUILabelTTF)
    if txtDifWord then 
        txtDifWord:setText(tDifName[self.checkTag])
    end
end

--@brief    宝箱奖励
--@param    nCurPageIndex:当前页数
function WndSingleCopy:_updateBoxReward(nCurPageIndex)
    -- body
    WZLog("WndSingleCopy:_updateBoxReward ----------=",nCurPageIndex)
    if self.m_root == nil then 
        return
    end
    if nCurPageIndex ~= nil and self.m_tCopyData ~= nil and nCurPageIndex > #self.m_tCopyData then
        return
    end
    local tLevelList = self.m_tCopyData[nCurPageIndex]

    local nTotalStar = #tLevelList*3 --星星总数
    self.m_nTotalStar = nTotalStar
    local nCurStar = self:_getSectionStarNum() -- 已通关星星数
    self.m_nCurStar = nCurStar
    local tRewardLocalData = self:getSectionReward(self.m_tCopyData[nCurPageIndex][1])

    local nPercent = 0
    local nLastStar = 0
    local rewardIndex = 1
    local nStar = tRewardLocalData["condition"..rewardIndex]

    local conBox = GetElement(self.m_root,"conReward3_WndSingleCopy",WZUIContainer)
    local txtRewardStar = GetElement(conBox,"txtRewardStar3_WndSingleCopy",WZUILabelTTF)
    local imgReward = GetElement(conBox, "imgReward3_WndSingleCopy", WZUIImage)
    local imgLight = GetElement(conBox, "imgLight3_WndSingleCopy", WZUIImage)
    local imgRedTip = GetElement(conBox,"imgRedTip3_WndSingleCopy",WZUIImage)
    local  armBox = GetElement(conBox,"armBox3_WndSingleCopy",WZArmature)
    armBox:setVisible(false)
    imgRedTip:setVisible(false)
    -- txtRewardStar:setText()
    local nState1 = self:_getSectionRewardStateByIndex(rewardIndex,self.m_nCurPageIndex,self.m_nCopyType)
    local nState2 = self:_getSectionRewardStateByIndex(rewardIndex+1,self.m_nCurPageIndex,self.m_nCopyType)
    local nState3 = self:_getSectionRewardStateByIndex(rewardIndex+1+1,self.m_nCurPageIndex,self.m_nCopyType)
    WZLog("_updateBoxReward1",nCurStar,nStar,nState1,nState2,nState3)
    if nCurStar < nStar then
        txtRewardStar:setText(nCurStar.."/"..nStar)
        imgLight:setVisible(true)
        imgLight:setFile("ui/common/common_icon_huang1.png")
        imgReward:setVisible(false) 
    else
        nStar = tRewardLocalData["condition"..rewardIndex+1]
        WZLog("_updateBoxReward2",nCurStar,nStar,nState1,nState2,nState3)
        if nCurStar < nStar then
            if nState1 == 1 then
                txtRewardStar:setText(nCurStar.."/"..nStar)
                imgLight:setVisible(true)
                imgLight:setFile("ui/common/common_icon_huang1.png")
                imgReward:setVisible(false)
            else
                WZLog("_updateBoxReward4")
                txtRewardStar:setText(nCurStar.."/"..nStar)
                imgLight:setVisible(true)
                imgLight:setFile("ui/common/common_icon_huang2.png")
                imgReward:setVisible(false)      
                armBox:setVisible(true)   
                imgRedTip:setVisible(true)          
            end  
        else
            nStar = tRewardLocalData["condition"..rewardIndex+1+1]
            WZLog("_updateBoxReward3",nCurStar,nStar,nState1,nState2,nState3)
            if nCurStar < nStar then
                if nState1 == 1 and nState2 == 1 then
                    txtRewardStar:setText(nCurStar.."/"..nStar)
                    imgLight:setVisible(true)
                    imgLight:setFile("ui/common/common_icon_huang1.png")
                    imgReward:setVisible(false)       
                else              
                    txtRewardStar:setText(nCurStar.."/"..nStar)
                    imgLight:setVisible(true)
                    imgLight:setFile("ui/common/common_icon_huang2.png")
                    imgReward:setVisible(false)  
                    armBox:setVisible(true)
                    imgRedTip:setVisible(true)
                end
            else
                if nState1 == 1 and nState2 == 1 and nState3 == 1 then
                    txtRewardStar:setText(nCurStar.."/"..nStar)
                    imgLight:setVisible(false)
                    imgLight:setFile("ui/common/common_icon_huang3.png")
                    imgReward:setVisible(true)                   
                else   
                    txtRewardStar:setText(nCurStar.."/"..nStar)
                    imgLight:setVisible(true)
                    imgLight:setFile("ui/common/common_icon_huang2.png")
                    imgReward:setVisible(false)      
                    armBox:setVisible(true)
                    imgRedTip:setVisible(true)
                end
            end
        end
    end
end

--@brief	更新星级奖励
--@param    nCurPageIndex:当前页数
function WndSingleCopy:_updateStarReward(nCurPageIndex)
    WZLog("WndSingleCopy:_updateStarReward ---------------= ",nCurPageIndex)
    if self.m_root == nil then
        return
    end
    local cell = WndSingleCopy:getCuPageObject()
    if cell == nil then
        return
    end

    if nCurPageIndex ~= nil and self.m_tCopyData ~= nil and nCurPageIndex > #self.m_tCopyData then
        return
    end

    local CellCopy = GetElement(cell,"CellCopy_WndSingleCopy",WZUIContainer)
    if CellCopy == nil then
        return
    end
   
    local tLevelList = self.m_tCopyData[nCurPageIndex]
    
    local nTotalStar = #tLevelList*3 --星星总数

    self.m_nTotalStar = nTotalStar
    local nCurStar = self:_getSectionStarNum() --已通关星星数
    self.m_nCurStar = nCurStar
                            
    local tRewardLocalData = self:getSectionReward(self.m_tCopyData[nCurPageIndex][1])

    local nPercent = 0
    local nLastStar = 0
    for i = 1, 3 do
        local conReward = GetElement(cell, "conReward" .. i .."_CellTreasureBox")
        if conReward ~= nil then
            local nStar = tRewardLocalData["condition"..i]
            local txtRewardStar = GetElement(conReward, "txtRewardStar" .. i .. "_CellTreasureBox", WZUILabelTTF)
            txtRewardStar:setText(nStar)
            local imgReward = GetElement(conReward, "imgReward"..i.."_CellTreasureBox", WZUIImage)
            local imgLight = GetElement(conReward, "imgLight"..i.."_CellTreasureBox", WZUIImage)
            local imgRedTip = GetElement(conReward,"imgRedTip" .. i .. "_CellTreasureBox",WZUIImage)
            local  armBox = GetElement(conReward,"armBox" .. i .. "_CellTreasureBox",WZArmature)
            armBox:setVisible(false)
            imgRedTip:setVisible(false)
            local nState = self:_getSectionRewardStateByIndex(i,self.m_nCurPageIndex,self.m_nCopyType)

            if i == 1 then  
                if nState == 0 then --nState状态, 0:未打开，1:已打开，2:可打开
                    imgLight:setVisible(true)
                    imgLight:setFile("ui/common/common_icon_lan1.png")
                    imgReward:setVisible(false)
                elseif nState == 1 then
                    imgLight:setVisible(false)
                    imgLight:setFile("ui/common/common_icon_lan1.png")
                    imgReward:setVisible(true)
                else
                    imgLight:setVisible(true)
                    imgLight:setFile("ui/common/common_icon_lan2.png")
                    imgReward:setVisible(false)
                    armBox:setVisible(true)
                    imgRedTip:setVisible(true)
                end
            elseif i == 2 then --可打开
                if nState == 0 then
                    imgLight:setVisible(true)
                    imgLight:setFile("ui/common/common_icon_zi1.png")
                    imgReward:setVisible(false)
                elseif nState == 1 then
                    imgLight:setVisible(false)
                    imgLight:setFile("ui/common/common_icon_zi1.png")
                    imgReward:setVisible(true)
                else
                    imgLight:setVisible(true)
                    imgLight:setFile("ui/common/common_icon_zi2.png")
                    imgReward:setVisible(false)
                    armBox:setVisible(true)
                    imgRedTip:setVisible(true)
                end
            else
                if  nState == 0 then
                    imgLight:setVisible(true)
                    imgLight:setFile("ui/common/common_icon_huang1.png")
                    imgReward:setVisible(false)
                elseif nState == 1 then
                    imgLight:setVisible(false)
                    imgLight:setFile("ui/common/common_icon_huang1.png")
                    imgReward:setVisible(true)
                else
                    imgLight:setVisible(true)
                    imgLight:setFile("ui/common/common_icon_huang2.png")
                    imgReward:setVisible(false)
                    armBox:setVisible(true)
                    imgRedTip:setVisible(true)
                end
            end
            
            if nCurStar >= nStar then
                nLastStar = nStar
            else
                nLastStar = -1
            end
        else
            return
        end
    end
    
    local txtStartCount = GetElement(cell,"txtStartCount_CellTreasureBox",WZUILabelTTF)
    if txtStartCount == nil then
        return
    end
    txtStartCount:setText(nCurStar)
    local imgPrg = GetElement(cell, "imgPrg_CellTreasureBox",WZUIProgress)
    local nP = nCurStar
    local totalStar = nTotalStar
   
    if self.m_nCurPageIndex == 0 and self.m_nCopyType == 1 then
        if nP > 9 and nP <= 12 then
            local percent = (nP+6) / (totalStar+12)
            percent = 100 * percent
            imgPrg:setPercentage(percent)
        elseif nP > 12 then
            local percent = (nP+12) / (totalStar+12)
            percent = 100 * percent
            imgPrg:setPercentage(percent)
        else
            local percent = nP / (totalStar+12)
            percent = 100 * percent
            imgPrg:setPercentage(percent)
        end
    else
        local percent = nP / totalStar
        percent = 100 * percent
        imgPrg:setPercentage(percent)
    end
end

function WndSingleCopy:scheduleResetTouchStats(element)
    WZLog("WndSingleCopy:scheduleResetTouchStats")
    element:disableSchedule()
    self.m_oPageCon:setTouchEnable(true)
    self.m_bLoadFinish = true 
end

function WndSingleCopy:onActionFinishBack()
    WZLog("WndSingleCopy:onActionFinishBack")
    self:_setCurrentPageIndex(self.m_nIndex)

    local playerLevel = CacheCenter:getPlayerInfo().level
    local frontDrawBoxStats = self:getFrontChapterBoxStats()
    if frontDrawBoxStats and self.m_root ~= nil and playerLevel > 10 and false then
        local conTip1 = GetElement(self.m_root,"conTip1_WndSingleCopy",WZUIContainer)
        conTip1:setVisible(true)
    end
    local behineDrawBoxStats = self:getBehindChapterBoxStats()
    if behineDrawBoxStats and self.m_root ~= nil and playerLevel > 10 and false then
        local conTip2 = GetElement(self.m_root,"conTip2_WndSingleCopy",WZUIContainer)
        conTip2:setVisible(true)
    end

    self:showCellInfo()

    if self.m_root ~= nil then
        WZLog("WndSingleCopy:_pageTurning two")
        if self.m_nIndex == 1 and self.m_luaCell == nil then
            TeachGroup1:startGroup({32,3,WndSingleCopy.m_root})
        end
    end
end


--@brief  预加载单人副本大地图资源
function WndSingleCopy:_preloadImg()
    WZLog("WndSingleCopy:_preloadImg")
    -- for i=1,self.m_nCurCopyIndex + 1 do
    --     local copyData = GDatatab_section["id_"..i]
    --     if copyData then
    --        local mapRes = copyData.map_resources
    --        CCTextureCache:sharedTextureCache():addImage("ui/copy/" .. mapRes)  --如果已有此缓存不会再次添加
    --     end
    -- end
end

function WndSingleCopy:setCurSectionData(tag)
    WZLog("CellSingleMap:onLoadData 1 =",tag)

    self:_createCellCopy(tag)

    for i,v in ipairs(WndSingleCopy.m_tEquipArmatures) do
        v:play("wait",true)
    end
    WndSingleCopy.m_tEquipArmatures = {}
    for i,v in ipairs(WndSingleCopy.m_tCellArmList) do
        if v.m_root then
            local conArm = GetElement(v.m_root,"conArm_CellSingleCopyLevel",WZUIContainer)
            if conArm then
                local childNode = conArm:getChildByTag(1145)
                if childNode ~= nil then
                    childNode = WZArmature:luaTo(childNode)
                    local status = v:getState()
                    local actionss = WZUIArmatureAnimationById:create()
                    actionss:setLoop(1)
                    if WndSingleCopy.m_nCopyType == 2 then
                        if status == CellSingleCopyLevel.STATE_LEVELUNREACHED or status == CellSingleCopyLevel.STATE_LOCKED then  
                            actionss:setAnimationId(1)
                        else
                            actionss:setAnimationId(0)
                        end
                        childNode:runUIAction(actionss)
                    elseif WndSingleCopy.m_nCopyType == 3 then

                        if status == CellSingleCopyLevel.STATE_LEVELUNREACHED or status == CellSingleCopyLevel.STATE_LOCKED then  
                            actionss:setAnimationId(3)
                        else
                            actionss:setAnimationId(2)
                        end
                        childNode:runUIAction(actionss)
                    end
                end
            end
        end
    end
    WndSingleCopy.m_tCellArmList = {}

    WndSingleCopy:addTreasureBox( self.m_root)
    WndSingleCopy:_updateCopyTitle(tag+1, self.m_root) 
    if WndSingleCopy.m_nCurPageIndex == tag then
        -- WndSingleCopy:_updateStarReward(tag+1) --更新星级奖励信息
        WndSingleCopy:_updateBoxReward(tag+1) --更新宝箱奖励
        WndSingleCopy.m_bInitFinish = true
        WndSingleCopy:showCellInfo()
    end
   
    --WndSingleCopy.m_nTaskCellId = nil  --任务跳转的章节ID
    WndSingleCopy.m_nJumpPageIndex = nil
    WndSingleCopy.m_oPageCon:setTouchEnable(true)

    if self.m_luaCell == nil then
        WndSingleCopy:teachStart(tag)
    else
        WindowManager:removeTeachShelterLayer()
    end
    WZLog("CellSingleMap:onLoadData 2", tostring(GlobalGame.m_nStoryId), tostring(GlobalGame.m_nStarNum), tostring(GlobalGame.m_nMapId))
    if GlobalGame.m_nStoryId then
        local isComment = false
        if GlobalGame.m_nStarNum and GlobalGame.m_nStarNum == 3 and GlobalGame.m_nMapId and GlobalGame.m_nMapId == 10208 then
            isComment = true
        end
        CreateStoryTalkGroup(GlobalGame.m_nStoryId, nil, nil, nil, nil, true, nil, nil, isComment)
    elseif GlobalGame.m_nStarNum and GlobalGame.m_nStarNum == 3 and GlobalGame.m_nMapId and GlobalGame.m_nMapId == 10208 then
        goGoogleUrl(WndSingleCopy)
    end
    GlobalGame.m_nStoryId = nil
    GlobalGame.m_nStarNum = nil
    GlobalGame.m_nMapId = nil
end


--@brief   每帧加载地图(防止进入单人副本时太慢的问题)
function WndSingleCopy:_loadMapPage()
    WZLog("WndSingleCopy:_loadMapPage")
    if not self.m_root then
        return
    end
    
    local curPageIndex = nil
    if SceneCopy.m_bTaskJump or self.m_nJumpPageIndex ~= nil then
        local pageIndex = nil
        if self.m_nJumpPageIndex ~= nil and self.m_nJumpPageIndex > 0 then
            pageIndex = self.m_nJumpPageIndex - 1
        else
            pageIndex = self.m_nCurCopyIndex-1
        end
        curPageIndex = pageIndex
        self.m_nCurPageIndex = curPageIndex
    else
        if GlobalGame.g_nSingleMapPage ~= nil and GlobalGame.g_nSingleMapPage ~= -1 and self.m_nCopyType == 1 then
            self.m_nCurPageIndex = GlobalGame.g_nSingleMapPage
        elseif GlobalGame.g_nEliteSingleMapPage ~= nil and GlobalGame.g_nEliteSingleMapPage ~= -1 and self.m_nCopyType == 2 then
            self.m_nCurPageIndex = GlobalGame.g_nEliteSingleMapPage
        else
            self.m_nCurPageIndex = self.m_nCurCopyIndex-1
        end
    end

    self:setCurSectionData(self.m_nCurPageIndex)  
    self:setSectionListData()

    local playerLevel = CacheCenter:getPlayerInfo().level
    local frontDrawBoxStats = self:getFrontChapterBoxStats()
    if frontDrawBoxStats and playerLevel > 10 and false then
        local conTip1 = GetElement(self.m_root,"conTip1_WndSingleCopy",WZUIContainer)
        conTip1:setVisible(true)
    end
    local behineDrawBoxStats = self:getBehindChapterBoxStats()
    if behineDrawBoxStats and playerLevel > 10 and false then
        local conTip2 = GetElement(self.m_root,"conTip2_WndSingleCopy",WZUIContainer)
        conTip2:setVisible(true)
    end
end

function WndSingleCopy:showCellInfo()
    WZLog("WndSingleCopy:showCellInfo =",self.m_bShowCopyLevelInfo,self.m_luaCell)
    if self.m_bShowCopyLevelInfo then
        if self.m_luaCell ~= nil then
            self:onClickLevelBack(self.m_luaCell)
        end
        self.m_bShowCopyLevelInfo = nil
    end
    self:_playSoundeffect()
end

--@brief  添加宝箱
function WndSingleCopy:addTreasureBox(pageNode)
    WZLog("WndSingleCopy:addTreasureBox")
    if pageNode ~= nil then
        local cellTreasureBox, cellTreasureBoxLua = CellTreasureBox:createElement()
        cellTreasureBox:setTag(899)
        cellTreasureBox:setVisible(false)
        pageNode:addChild(cellTreasureBox)
        cellTreasureBoxLua:setTreasureChestCallBack(self.onClickReward,self)
        self.m_tFirstCellTreasureBox = self.m_tFirstCellTreasureBox or cellTreasureBox
    end
end

--@brief    创建章节列表
function WndSingleCopy:_createSectionList(element)
    -- body
    local tbSectionList = GetElement(self.m_root, "tbSectionList_WndSingleCopy", WZUITableContainer)
    tbSectionList:cleanTable()
    self.m_tCellSectionItem = {}
    local tSectionData = self.m_tSectionListData[self.m_nCopyType]
    WZLog("WndSingleCopy:_createSectionList", self.m_nCurPageIndex)
    for i = 1, #tSectionData do
        local element, tNewObj = CellSingleCopySectionItem:createElement()
        if element and tNewObj then 
            element:setTag(i - 1)
            tNewObj:setData(tSectionData[i])
            tbSectionList:setCellElement(element)
            if tSectionData[i].section_id == self.m_nCurPageIndex + 1 then 
                tNewObj:setSelState(true)
                self.m_tCellSectionSel = tNewObj 
            else
                tNewObj:setSelState(false)
            end
            --红点
            local nState = 0 
            for k = 1, 3 do
                nState = self:_getSectionRewardStateByIndex(k, tSectionData[i].section_id - 1, self.m_nCopyType)
                if nState == 2 then 
                    break 
                end
            end
            if nState == 2 then
                tNewObj:setReDot(true)
            else
                tNewObj:setReDot(false)
            end
            table.insert(self.m_tCellSectionItem, tNewObj)
        end
    end

    self:_setSectionListPos(element)
end

--@brief    设置章节列表位置
function WndSingleCopy:_setSectionListPos(element)
    -- body
    local tbSectionList = GetElement(self.m_root, "tbSectionList_WndSingleCopy", WZUITableContainer)
    local cellHeight = 110
    if self.m_nCurCopyIndex > 4 then
        local nCurPositionY = tbSectionList:getMinPosition().y + (self.m_nCurCopyIndex - 4) * cellHeight
        if nCurPositionY > tbSectionList:getMaxPosition().y then 
            nCurPositionY = tbSectionList:getMaxPosition().y
        end
        tbSectionList:getMoveElement():setPositionY(nCurPositionY)
    end
end

--@brief    展示当前的任务
function WndSingleCopy:showCurTask()
    -- body
    if self.m_root == nil then return end 

    local ftxtTaskDesc = GetElement(self.m_root, "ftxtTaskDesc_WndSingleCopy", WZUIFreeTextBox)
    local formatString = [[<T C="255,236,193" S="18" P="1" SC="132,66,29" SS="4" SE="1">%s</T><T C="255,236,193" S="18" P="1" SC="132,66,29" SS="4" SE="1">(%d/%d)</T>]]
    self.m_curTaskData = nil 
    local taskList = PrefetchCache:getSingleCopyTask()
    if taskList and taskList[1] then 
        local nComplete = taskList[1].nTargetStatus
        local taskData = GDatatab_task["id_" .. taskList[1].nId]
        self.m_curTaskData = taskList[1]
        if taskList[1].nTaskStatus == TASKSTATUS_TOSUBMIT then 
            formatString = [[<T C="255,236,193" S="18" P="1" SC="132,66,29" SS="4" SE="1">%s</T><T C="99,255,95" S="18" P="1" SC="132,66,29" SS="4" SE="1">(%s)</T>]]
            ftxtTaskDesc:setShowText(string.format(formatString, taskData.desc, LocalStrings.ACTIVE_FINISH))
            return
        end
        ftxtTaskDesc:setShowText(string.format(formatString, taskData.desc, nComplete, taskList[1].nTargetValue))
    else
        formatString = [[<T C="255,236,193" S="18" P="1" SC="132,66,29" SS="4" SE="1">%s</T>]]
        ftxtTaskDesc:setShowText(string.format(formatString, LocalStrings.TASK_NEWTEXT1))
    end
end

--@brief    点击领取宝箱奖励事件
function WndSingleCopy:_postGetBoxRewardEvent()
    -- body
    local level = CacheCenter:getPlayerInfo().level
    if level >= 2 and level <= 10 then 
        local eventKey = PostPlayerEvent["event_clickSingleCopyBox" .. level]
        if eventKey then 
            PostPlayerEvent:postEvent(eventKey)    
        end
    end
end

--@brief    点击组队副本
function WndSingleCopy:onClickTeam(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    ProtocolProcessorWndTask:send_PLAYER_GetHonourInfo( )
    WindowManager:removeWindow(self.m_root, self, true)

end

--@brief    翻页
--@param    nToIndex:要翻到的页数
function WndSingleCopy:_pageTurning(nToIndex)
    WZLog("WndSingleCopy:_pageTurning .... = ",nToIndex)
    self.m_oPageCon:setTouchEnable(false)

    local conCnt = GetElement(self.m_root,"conCnt_WndSingleCopy",WZUIContainer)
    
    local cell = self:getCuPageObject()
    if cell == nil then
        return
    end
    self:setCurSectionData(nToIndex)
    self.m_nIndex = nToIndex
    conCnt:enableSchedule("scheduleResetTouchStats",0.7)  --为了更好的操作体验，提前设置了当前页
    self.m_bLoadFinish = false

   self:onActionFinishBack()
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin------------------------------------------
function WndSingleCopy:_adaptLanguage_en()
    WZLog("WndSingleCopy:_adaptLanguage_en ")
    local txtTip1 = GetElement(self.m_root,"txtTip1_WndSingleCopy",WZUILabelTTF)
    txtTip1:setRelativePosition(GlobalMethod:ccp(0.534334,0.5))
    txtTip1:setScale(0.9)

    local txtTip2 = GetElement(self.m_root,"txtTip2_WndSingleCopy",WZUILabelTTF)
    txtTip2:setRelativePosition(GlobalMethod:ccp(0.487124,0.5))
    txtTip2:setScale(0.9)
end

function WndSingleCopy:_adaptLanguage_pt()
    local txtTip1 = GetElement(self.m_root,"txtTip1_WndSingleCopy",WZUILabelTTF)
    txtTip1:setScale(0.9)
    txtTip1:setDimensions(GlobalMethod:CCSize(220))

    local txtTip2 = GetElement(self.m_root,"txtTip2_WndSingleCopy",WZUILabelTTF)
    txtTip2:setScale(0.9)
    txtTip2:setDimensions(GlobalMethod:CCSize(220))
    txtTip2:setRelativePosition(GlobalMethod:ccp(0.487124,0.49))
end
function WndSingleCopy:_adaptLanguage_tr()
    local txtTip1 = GetElement(self.m_root,"txtTip1_WndSingleCopy",WZUILabelTTF)
    txtTip1:setRelativePosition(GlobalMethod:ccp(0.534334,0.5))
    txtTip1:setScale(0.9)
    local txtTip2 = GetElement(self.m_root,"txtTip2_WndSingleCopy",WZUILabelTTF)
    txtTip2:setRelativePosition(GlobalMethod:ccp(0.487124,0.5))
    txtTip2:setScale(0.9)
end

function WndSingleCopy:_adaptLanguage_ug()
    local txtTip1 = GetElement(self.m_root,"txtTip1_WndSingleCopy",WZUILabelTTF)
    txtTip1:setDimensions(GlobalMethod:CCSize(280))
    txtTip1:setScale(0.7)
    local txtTip2 = GetElement(self.m_root,"txtTip2_WndSingleCopy",WZUILabelTTF)
    txtTip2:setDimensions(GlobalMethod:CCSize(280))
    txtTip2:setScale(0.7)
end
-------------------------------------语言适配End--------------------------------------------
