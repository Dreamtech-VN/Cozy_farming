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
    ChangeChatChannel(Chat_Channel_Single_Copy_Hall)
    --self.m_nLoadingId = MsgBoxManager:showLoadingBox()
    CacheCenter:registerUpatePlayerInfoObserver(self)--注册人物
    ProtocolProcessorSingleMap:send_MAP_GetLandlordData()
    
    AdaptLanguage(self)
end

--@brief    
function WndSingleCopy:afterProtocolCallBack()
    -- body
    self:_initData()
    self:_preloadImg()
    self:_initUI()
    --SoundManager:playBgMusic(SoundDefine.E_MUSIC_HALL)
    --SoundManager:stopBgMusic()
    
    WndGangsterInn:show()
    
    self:teachOnRefresh()
end

function WndSingleCopy:onEnterTransitionDidFinish(element)
    --黑市商人出现
	self:setSectionListData()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndSingleCopy:onExit(element)
    CacheCenter:unregisterUpatePlayerInfoObserver(self)--注册人物
    -- SoundManager:playBgMusic(SoundDefine.E_MUSIC_HALL)
	self:_unInit()
end

--@brief 教学
function WndSingleCopy:teachStart(tag)
        local isEndTeach1, step1 = TeachGroup1:isTeachFinish(1)
        local isEndTeach3, step3 = TeachGroup1:isTeachFinish(3)
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

        WZLog("WndSingleCopy:_loadMapPage one", tostring(GlobalGame.m_nStoryId), isEndTeach39, step39, isEndTeach40, step40, TeachGroup1:isTaskTeachFinish(10201), tostring(MsgBoxManager:_getCurHighestPriorityMsg()))
        local isTeach = true
        if isEndTeach29 ~= true and step29 > 0 and self.m_nCopyType == 2 then
            isTeach = TeachGroup1:startGroup({29,4,WndSingleCopy.m_oCurPage})
        elseif isEndTeach29 ~= true and step29 > 0 and self.m_nCopyType ~= 2 then
            isTeach = TeachGroup1:startGroup({29,3,WndSingleCopy.m_root})
        elseif isEndTeach40 ~= true and TeachGroup1:isTaskTeachFinish(10206) then
            if GlobalGame.g_tWndBottomBarObj == nil then
                isTeach = false
            end
            isTeach = TeachGroup1:startGroup({40,1,GlobalGame.g_tWndBottomBarObj.m_root})
        elseif isEndTeach39 ~= true and TeachGroup1:isTaskTeachFinish(10205) then
            if GlobalGame.g_tWndBottomBarObj == nil then
                isTeach = false
            end
            isTeach = TeachGroup1:startGroup({39,1,GlobalGame.g_tWndBottomBarObj.m_root})
        elseif isEndTeach36 ~= true and TeachGroup1:isTaskTeachFinish(10204) then
            if GlobalGame.g_tWndBottomBarObj == nil then
                isTeach = false
            end
            isTeach = TeachGroup1:startGroup({36,1,GlobalGame.g_tWndBottomBarObj.m_root})
        elseif isEndTeach35 ~= true and TeachGroup1:isTaskTeachFinish(10203) and WndDressUp.m_root == nil and MsgBoxManager:_getCurHighestPriorityMsg() == nil  then
            if GlobalGame.g_tWndBottomBarObj == nil then
                isTeach = false
            end
            isTeach = TeachGroup1:startGroup({35,1,GlobalGame.g_tWndBottomBarObj.m_root})
        elseif isEndTeach34 ~= true and TeachGroup1:isTaskTeachFinish(10202) then
            if GlobalGame.g_tWndBottomBarObj == nil then
                isTeach = false
            end
            isTeach = TeachGroup1:startGroup({34,1,GlobalGame.g_tWndBottomBarObj.m_root})
        elseif isEndTeach33 ~= true and TeachGroup1:isTaskTeachFinish(10201) then
            if GlobalGame.g_tWndBottomBarObj == nil then
                isTeach = false
            end
            isTeach = TeachGroup1:startGroup({33,1,GlobalGame.g_tWndBottomBarObj.m_root})
        elseif isEndTeach32 ~= true and TeachGroup1:isTaskTeachFinish(10105) and tag == 0 then
            if true or step32 < 4 then
                if GlobalGame.g_tWndBottomBarObj == nil then
                    isTeach = false
                end
                isTeach = TeachGroup1:startGroup({32,1,GlobalGame.g_tWndBottomBarObj.m_root})
            else
                isTeach = TeachGroup1:startGroup({32,7,self.m_oCurPage})
            end
        elseif isEndTeach31 ~= true and TeachGroup1:isTaskTeachFinish(10104) then
            if GlobalGame.g_tWndBottomBarObj == nil then
                isTeach = false
            end
            isTeach = TeachGroup1:startGroup({31,1,GlobalGame.g_tWndBottomBarObj.m_root})
        elseif isEndTeach7 ~= true and TeachGroup1:isTaskTeachFinish(10103) and self.m_tFirstCellTreasureBox then
            isTeach = TeachGroup1:startGroup({7,1,self.m_tFirstCellTreasureBox})
        elseif isEndTeach3 == true and isEndTeach5 ~= true then
            isTeach = TeachGroup1:startGroup({5,13,WndSingleCopy.m_oCurPage})
        elseif isEndTeach7 == true and isEndTeach8 == false and TeachGroup1.STEP < 5  then
            if GlobalGame.g_tWndBottomBarObj == nil then
                isTeach = false
            end
            isTeach = TeachGroup1:startGroup({8,2, GlobalGame.g_tWndBottomBarObj.m_root})
        elseif isEndTeach7 == true and isEndTeach8 == false and TeachGroup1.STEP >= 5  then
            isTeach = TeachGroup1:startGroup({8,10,WndSingleCopy.m_oCurPage})
        elseif isEndTeach7 == true and isEndTeach9 ~= true then
            isTeach = TeachGroup1:startGroup({9,10,WndSingleCopy.m_oCurPage})
        elseif isEndTeach1 == true and isEndTeach3 == false and step3 < 5  then
            if GlobalGame.g_tWndBottomBarObj == nil then
                isTeach = false
            end
            isTeach = TeachGroup1:startGroup({3,1, GlobalGame.g_tWndBottomBarObj.m_root})
        elseif isEndTeach1 == true and isEndTeach3 == false and step3 >= 5  then
            isTeach = TeachGroup1:startGroup({3,6,WndSingleCopy.m_oCurPage})
        else
            isTeach = TeachGroup1:startGroup({1,4,self.m_oCurPage})
        end

        WZLog("WndSingleCopy:_loadMapPage two", tostring(isTeach))
        if isTeach == false then
            WindowManager:removeTeachShelterLayer()
        end
end

--@brief 刷新教学
function WndSingleCopy:teachOnRefresh()
        local isEndTeach1, step1 = TeachGroup1:isTeachFinish(1)
        local isEndTeach3, step3 = TeachGroup1:isTeachFinish(3)
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
        elseif isEndTeach3 == true and isEndTeach5 ~= true then
            isTeach = true
        elseif isEndTeach7 == true and isEndTeach8 == false and TeachGroup1.STEP < 5  then
            isTeach = true
        elseif isEndTeach7 == true and isEndTeach8 == false and TeachGroup1.STEP >= 5  then
            isTeach = true
        elseif isEndTeach1 == true and isEndTeach3 == false and step3 < 5  then
            isTeach = true
        elseif isEndTeach1 == true and isEndTeach3 == false and step3 >= 5  then
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
    self:_hideSectionList()
    if nIndex == nil then
        nIndex = self.m_oPageCon:getCurrentPageIndex()
    end
    if  self.m_nCurPageIndex == nIndex then
        return
    end
    WZLog("WndSingleCopy:onPageChanged = ",nIndex)

    self:_setCurrentPageIndex(nIndex)
    local frontDrawBoxStats = self:getFrontChapterBoxStats()
    if frontDrawBoxStats then
        local conTip1 = GetElement(self.m_root,"conTip1_WndSingleCopy",WZUIContainer)
        conTip1:setVisible(true)
    end
    local behineDrawBoxStats = self:getBehindChapterBoxStats()
    if behineDrawBoxStats then
        local conTip2 = GetElement(self.m_root,"conTip2_WndSingleCopy",WZUIContainer)
        conTip2:setVisible(true)
    end
    self:_playSoundeffect()
end

--@brief	点击关卡时的回调
--@param	tCellLevel:被点击的关卡绑定的lua对象
function WndSingleCopy:onClickLevelBack(tCellLevel)
    WZLog("WndSingleCopy:onClickLevelBack ")
    
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

    local conTip1 = GetElement(WndSingleCopy.m_root,"conTip1_WndSingleCopy",WZUIContainer)
    if conTip1 then
        conTip1:setVisible(false)
    end

    local conTip2 = GetElement(WndSingleCopy.m_root,"conTip2_WndSingleCopy",WZUIContainer)
    if conTip2 then
        conTip2:setVisible(false)
    end

    if WndDressUp.m_root ~= nil and (not WndDressUp:checkPoint(pt)) then
        WndDressUp:onCloseClick()
    end

    local conSectionItem = GetElement(self.m_root, "conSectionItem_WndSingleCopy", WZUIContainer)
    if conSectionItem:isVisible() then 
        if not self:_checkBtnPoint(pt) then 
            conSectionItem:setVisible(false)
            --旋转箭头
            local curPage = self:getCuPageObject()
            local CellCopy = GetElement(curPage, "CellCopy_WndSingleCopy", WZUIContainer)
            if CellCopy == nil then
                return
            end
            local imgCircleArrow = GetElement(CellCopy, "imgCircleArrow_WndSingleCopy", WZUIImage)
            if imgCircleArrow then 
                imgCircleArrow:setRotation(0)
            end
        end
    end
end

--@brief    关闭章节列表
function WndSingleCopy:_hideSectionList()
    -- body
    local conSectionItem = GetElement(self.m_root, "conSectionItem_WndSingleCopy", WZUIContainer)
    conSectionItem:setVisible(false)
    --旋转箭头
    local curPage = self:getCuPageObject()
    local CellCopy = GetElement(curPage, "CellCopy_WndSingleCopy", WZUIContainer)
    if CellCopy == nil then
        return
    end
    local imgCircleArrow = GetElement(CellCopy, "imgCircleArrow_WndSingleCopy", WZUIImage)
    if imgCircleArrow then 
        imgCircleArrow:setRotation(0)
    end
end

--@brief    检查是否按下在按钮下
function WndSingleCopy:_checkBtnPoint(pt)
    --body
    local btn = GetElement(self.m_root, "conSectionItem_WndSingleCopy", WZUIContainer)
    if btn then
        local x = btn:getPositionX()
        local y = btn:getPositionY()
        local pt1 = btn:convertToNodeSpace(GlobalMethod:ccp(pt.x,pt.y))
        local btnSize = btn:getContentSize()
        if pt1.x > 0 and pt1.x < btnSize.width and pt1.y > 0 and pt1.y < btnSize.height then
            return true
        end
    end

    btn = GetElement(self.m_root, "btnTemp_WndSingleCopy", WZUIButton)
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
    
    local nStatus = self:_getSectionRewardStateByIndex(nIndex)
   
    if nStatus == 0 then --未打开
        --self:_showRewardTips(nIndex, false)
		WndTips:show(element,self.m_root,3,self:getTipReward(nIndex),GlobalMethod:ccp(160,130))
		WndTips.m_root:setShowAll(true)
    elseif nStatus == 1 then --已打开
        --self:_showRewardTips(nIndex, true)
		WndTips:show(element,self.m_root,3,self:getTipReward(nIndex),GlobalMethod:ccp(160,130))
		WndTips.m_root:setShowAll(true)
    elseif nStatus == 2 then --可打开
        local nMapGroup = nil
        nMapGroup = self.m_tCopyData[self.m_nCurPageIndex+1][1].section
        ProtocolProcessorSingleMap:send_SINGLEMAP_GetSectionReward(nMapGroup,self.m_nCopyType,nIndex)
        self.m_bGetRewardItems = true
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
    self:showCopyType(element)
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

    TeachGroup1:endTeachStep({29,3})
    if self.m_nCopyType == 2 then
        return
    end
    self:changeEliteCopy()
end

--@brief  选择噩梦模式
function WndSingleCopy:onClickDevilType(element)
    WZLog("WndSingleCopy:onClickDevilType")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

    TeachGroup1:endTeachStep({29,3})
    if self.m_nCopyType == 3 then
        return
    end
    self:changeDevilCopy()
end

--@brief  切换到单人副本的普通模式
function WndSingleCopy:changeCopyModel()
    WZLog("WndSingleCopy:changeCopyModel")
    local count = 1
    local tCopyData = nil
    for i=1,self.m_createPageCount do
        tCopyData = self.m_tCopyData[i]
        for i,v in ipairs(tCopyData) do
            local nState = self:_getLevelState(v)
            local copyCell = self.m_tAllCopyCell[count]
            copyCell:setData(v)
            copyCell:setState(nState)
            count = count + 1
        end
    end
end

--@brief    点击小岛按钮回调
function WndSingleCopy:onClickIsland(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

    WndSingleCopyMyIsland:showInterface(self.m_tIslandHostId, self.m_tNextHostId)
end

--@brief    点击展示通关章节按钮回调
function WndSingleCopy:onClickSectionArrow(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    WZLog("WndSingleCopy:onClickSectionArrow")
    local parentNode = element:getParentElement()
    parentNode = WZUIContainer:luaTo(parentNode)
    if parentNode == nil then return end 

    local conSectionItem = GetElement(self.m_root, "conSectionItem_WndSingleCopy", WZUIContainer)
    local imgCircleArrow = GetElement(parentNode, "imgCircleArrow_WndSingleCopy", WZUIImage)
    if conSectionItem:isVisible() then 
        conSectionItem:setVisible(false)
        imgCircleArrow:setRotation(0)
    else
        conSectionItem:setVisible(true)
        imgCircleArrow:setRotation(180)

        self:_createSectionList()
    end
end

function WndSingleCopy:onChangeSection(sectionId)
    -- body
    if sectionId == self.m_nCurPageIndex + 1 then return end 

    local conSectionItem = GetElement(self.m_root, "conSectionItem_WndSingleCopy", WZUIContainer)
    conSectionItem:setVisible(false)
    --旋转箭头
    local curPage = self:getCuPageObject()
    local CellCopy = GetElement(curPage, "CellCopy_WndSingleCopy", WZUIContainer)
    if CellCopy == nil then
        return
    end
    local imgCircleArrow = GetElement(CellCopy, "imgCircleArrow_WndSingleCopy", WZUIImage)
    if imgCircleArrow then 
        imgCircleArrow:setRotation(0)
    end
    
    WndSingleCopy:resertCurPage(sectionId-1)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	初始化界面
function WndSingleCopy:_initUI()
    if self.m_root == nil then
        return
    end
    
    local pgconCopy = GetElement(self.m_root, "pgconCopy_WndSingleCopy", WZUIPageContainer)
    pgconCopy:UpdateInsidePosition()
    pgconCopy:setTouchEnable(false)
    self.m_oPageCon = pgconCopy

    local btnPrevious = GetElement(self.m_root,"btnPrevious_WndSingleCopy",WZUIButton)
    local btnNext = GetElement(self.m_root,"btnNext_WndSingleCopy",WZUIButton)
    btnPrevious:setTouchEnable(false)
    btnNext:setTouchEnable(false)

    self.m_nPageNum = #self.m_tCopyData 

    local createCount = self.m_nCurCopyIndex
    if createCount < self.m_nPageNum then
        createCount = self.m_nCurCopyIndex+1
    end
    self.m_createPageCount = createCount
    pgconCopy:setMoveActionFinishCallback("onPageChanged")
    pgconCopy:enableSchedule("_loadMapPage",0.3)
end

--@brief    创建副本页
--@param    nTag,序号
--@return   #1,副本页UI节点
function WndSingleCopy:_createCellCopy(nTag)
    WZLog("WndSingleCopy:_createCellCopy ",nTag,self.m_nCurCopyIndex)
    local GetElement = GetElement
    local cellCopy = CreateElement("CellCopy_WndSingleCopy")
    local txtTitle = GetElement(cellCopy,"txtTitle_CellCopy",WZUILabelTTF)
    if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "pt" then
        local conMapTitle = GetElement(cellCopy,"conMapTitle_CellCopy",WZUIContainer)
        conMapTitle:setAbsContentSize(GlobalMethod:CCSize(246,62))

        local imgTitleBg = GetElement(conMapTitle,"imgTitleBg_CellCopy",WZUIImage)
        imgTitleBg:setUseOriginSize(false)
        txtTitle:setDimensions(GlobalMethod:CCSize(270,0))
        txtTitle:setScale(0.6)  
        GetElement(cellCopy,"txtIsland1_WndSingleCopy",WZUILabelTTF):setScale(0.6)
        GetElement(cellCopy,"txtIsland2_WndSingleCopy",WZUILabelTTF):setScale(0.6)  
    elseif  ProjConfig.LANGUAGE == "vn" then
        txtTitle:setFontSize(20)
    elseif ProjConfig.LANGUAGE == "es" then
        txtTitle:setDimensions(GlobalMethod:CCSize(270,0))
        txtTitle:setScale(0.6)  
    end
    if  ProjConfig.LANGUAGE == "tr" then
        local txtTitle = GetElement(cellCopy,"txtTitle_CellCopy",WZUILabelTTF)
        txtTitle:setScale(0.6)
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

    imgCopyBg:setFile("ui/copy/" .. mapResources)
    table.insert(self.m_tAllCopyPage,cellCopy)
    if nTag+1 == self.m_nCurCopyIndex then
        self.m_oCurPage = cellCopy
        if nTag == 1 then
            self.m_oPageOne = cellCopy
        end
    else
        if nTag == 1 then
            self.m_oPageOne = cellCopy
        end
        --cellCopy:setVisible(false)
        --table.insert(self.m_tNeedSetFileImg,cellCopy)
    end
    local playerLevel = CacheCenter:getPlayerInfo().level
    local btnInfo1 = GDatatab_button_info["id_" .. 57]
    local btnInfo2 = GDatatab_button_info["id_" .. 81]
    local cbCommon = GetElement(cellCopy,"cbCommon_WndSingleCopy",WZUICheckBox)
    local cbElite = GetElement(cellCopy,"cbElite_WndSingleCopy",WZUICheckBox)
    local cbDevil = GetElement(cellCopy,"cbDevil_WndSingleCopy",WZUICheckBox)
    if playerLevel < btnInfo1.open_level then
        cbCommon:setVisible(false)
        cbElite:setVisible(false)
        cbDevil:setVisible(false)
    elseif playerLevel >= btnInfo1.open_level and playerLevel < btnInfo2.open_level then
        cbCommon:setVisible(true)
        cbElite:setVisible(true)
        cbDevil:setVisible(false)
    end

    
    local conList = GetElement(self.m_root,"conList_WndChallengeEntrance",WZUIContainer)
    
    local sectionCellOrder = 20
    local countLevel = #tCopyData
    self:showCopyType(cellCopy)
    
    if nTag ~= 0 or (nTag == 0 and self:teach(tCopyData, countLevel, cellCopy) == false) then
        for i,v in pairs(tCopyData) do
            local cellLevel = self:_createLevel(i, v,countLevel)
            if cellLevel then
                cellCopy:addChild(cellLevel)
                cellLevel:setZOrder(sectionCellOrder)
                sectionCellOrder = sectionCellOrder - 1
            end
        end
    end

    --小岛按钮
    self:setIslandBtnVisible(cellCopy)
    return cellCopy
end

--@brief    教学创建关卡
function WndSingleCopy:teach(tCopyData, countLevel, cellCopy)
    do return false end
    if CacheCenter:getPlayerInfo().level > 3 then
        return false
    end

    local isEndTeach1, step1 = TeachGroup1:isTeachFinish(1)
    local isEndTeach3, step3 = TeachGroup1:isTeachFinish(3)
    local isEndTeach5, step5 = TeachGroup1:isTeachFinish(5)
    local isEndTeach7, step7 = TeachGroup1:isTeachFinish(7)
    local isEndTeach8, step8 = TeachGroup1:isTeachFinish(8)

    WZLog("WndSingleCopy:teach one", tostring(isEndTeach1), tostring(isEndTeach3), tostring(isEndTeach5), tostring(isEndTeach8))
    ProtocolProcessorSingleMap:regAll()

    if isEndTeach1 ~= true and step3 == 0 then
        level = 1
    elseif isEndTeach3 ~= true and (isEndTeach1 == true or step3 > 0) then
        level = 2
    elseif isEndTeach5 ~= true and (isEndTeach3 == true or step5 > 0) then
        level = 3
    elseif isEndTeach8 ~= true and (isEndTeach5 == true or step8 > 0) then
        level = 4
    else
        return false
    end
    --level = 1

    for i,v in pairs(tCopyData) do
        local state
        if i == level then
            state = CellSingleCopyLevel.STATE_UNDERWAY
        elseif i < level then
            state = CellSingleCopyLevel.STATE_PASSED
        elseif i > level then
            state = CellSingleCopyLevel.STATE_LOCKED
        end
        WZLog("WndSingleCopy:teach two", i, state)
        local cellLevel = self:_createLevel(i, v, countLevel, state)
        if cellLevel then
            cellCopy:addChild(cellLevel,0,i)
        end
    end
end

--@brief    创建关卡
--@param    nTag,序号
--@param    tLevelData,关卡数据表
--@return   #1,关卡UI节点
function WndSingleCopy:_createLevel(nTag, tLevelData,levelCount, state)
    local eCellLevel, tCellLevel = CellSingleCopyLevel:createElement()
    tCellLevel:setTag(nTag)
    tCellLevel:setData(tLevelData)

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
        if sectionData.boss == nil then
            return
        end
        local stP,enP = string.find(sectionData.boss,".altas")
        tCellLevel:setArmStats(false)
        if stP ~= nil or endP ~= nil then

            stP,enP = string.find(sectionData.boss,".altas")
            local animName = string.sub(sectionData.boss,0,stP-1)
            local anim = BattleAnimation:createAnimation(animName,false,"battle/monster")
            local animNode = anim:getAnimNode()
            animNode:setTouchEnable(false)
            animNode:setAnchorPoint(GlobalMethod:ccp(0.5,0.0))
            animNode:setRelativePosition(GlobalMethod:ccp(0.5,0.35))
            animNode:setUseOriginSize(true)
            animNode:setScale(0.4)
            animNode:setZOrder(99)
            if tLevelData.section == 6 then
                animNode:setScale(0.27)
            elseif tLevelData.section == 5 then
                animNode:setScale(0.3)
            elseif tLevelData.section == 3 then
                animNode:setScale(0.6)
            elseif tLevelData.section == 7 or  tLevelData.section == 8  then
                animNode:setScale(0.35)
                animNode:setRelativePosition(GlobalMethod:ccp(0.52,0.3))
            elseif tLevelData.section == 13 then
                animNode:setScale(0.3)
            end
            eCellLevel:addChild(animNode)
            table.insert(self.m_tArmatures,anim)
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
    if self.m_nTaskCellId ~= nil then
        tCellLevel:setTaskCellId(self.m_nTaskCellId)
        local singleMapData = GDatatab_single_map["id_" .. self.m_nTaskCellId ]
        if self.m_bShowCopyLevelInfo and singleMapData and (self.m_nTaskCellId == tLevelData.id or (tLevelData.map_type == 3 and singleMapData.section == tLevelData.section and singleMapData.idgroup == tLevelData.idgroup )) then
            self.m_luaCell = tCellLevel
        end
    end
    return eCellLevel
end


--@brief	设置当前页数
--@param    nIndex:页数
function WndSingleCopy:_setCurrentPageIndex(nIndex)
    WZLog("WndSingleCopy:_setCurrentPageIndex = ",nIndex)
    if self.m_root == nil or nIndex == nil then
        return
    end
    self.m_nCurPageIndex = nIndex
    
    self:_updateStarReward(nIndex+1) --更新星级奖励信息
    self:_updatePageButton(nIndex) --更新翻页按钮
    
end


--@brief	更新副本标题
--@param    nCurPageIndex:当前页数
function WndSingleCopy:_updateCopyTitle(nCurPageIndex,pageNode)
    WZLog("WndSingleCopy:_updateCopyTitle = ",nCurPageIndex,#self.m_tCopyData)
    local txtTitle = GetElement(pageNode, "txtTitle_CellCopy", WZUILabelTTF)
    local tLevelList = self.m_tCopyData[nCurPageIndex]
    if tLevelList and #tLevelList > 0 then
        txtTitle:setText(tLevelList[1].section_name)
    end
    
end

--@brief	更新星级奖励
--@param    nCurPageIndex:当前页数
function WndSingleCopy:_updateStarReward(nCurPageIndex)
    WZLog("WndSingleCopy:_updateStarReward ---------------= ",nCurPageIndex)
    if self.m_root == nil then
        return
    end
    local pgconCopy = GetElement(self.m_root, "pgconCopy_WndSingleCopy", WZUIPageContainer)
    local cell = pgconCopy:getPageElement(nCurPageIndex - 1)
    if cell~= nil then
        cell = WZUIContainer:luaTo(cell)
    else
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

--@brief	更新翻页按钮
--@param    nCurPageIndex:当前页数
function WndSingleCopy:_updatePageButton(nCurPageIndex)
    WZLog("WndSingleCopy:_updatePageButton =",nCurPageIndex)
    local btnNext = GetElement(self.m_root, "btnNext_WndSingleCopy")
    local btnPrevious = GetElement(self.m_root, "btnPrevious_WndSingleCopy")
    
    if nCurPageIndex == 0 then
        btnNext:setVisible(true)
        btnPrevious:setVisible(false)
    elseif nCurPageIndex+1 >= #self.m_tCopyData then
        btnNext:setVisible(false)
        btnPrevious:setVisible(true)
    else
        btnNext:setVisible(true)
        btnPrevious:setVisible(true)
    end
end

--@brief    翻页
--@param    nToIndex:要翻到的页数
function WndSingleCopy:_pageTurning(nToIndex)
    WZLog("WndSingleCopy:_pageTurning .... = ",nToIndex)
    local pgconCopy = GetElement(self.m_root, "pgconCopy_WndSingleCopy", WZUIPageContainer)
    pgconCopy:setTouchEnable(false)

    local conCnt = GetElement(self.m_root,"conCnt_WndSingleCopy",WZUIContainer)
    
    local cell = pgconCopy:getPageElement(nToIndex)
    local movePsx , movePsy = pgconCopy:getMoveElement():getPosition()
    cell = WZUIContainer:luaTo(cell)
    if cell == nil then
        return
    end
    self.m_nIndex = nToIndex
    conCnt:enableSchedule("scheduleResetTouchStats",0.7)  --为了更好的操作体验，提前设置了当前页

    pgconCopy:UpdateInsidePosition()
    pgconCopy:getMoveElement():stopAllActions()
    local minX = pgconCopy:getMinPosition().x
    local maxX = pgconCopy:getMaxPosition().x
    local psX,psY = cell:getPosition()
    local moX = maxX - nToIndex*932
    WZLog("WndSingleCopy:_pageTurning moX =",moX)
    self.m_bLoadFinish = false

    local moveTo = WZUIActionMoveToPosition:create()
    moveTo:setPosition(GlobalMethod:ccp(moX,psY))
    moveTo:setDuration(0.6)

    local sequence = WZUIActionSequence:create()
    sequence:setChildAction(moveTo)
    sequence:setFinishLuaFunction("onActionFinishBack")
    pgconCopy:getMoveElement():stopAllActions()
    pgconCopy:getMoveElement():runUIAction(sequence)
     

end

function WndSingleCopy:scheduleResetTouchStats(element)
    WZLog("WndSingleCopy:scheduleResetTouchStats")
    element:disableSchedule()
    local pgconCopy = GetElement(self.m_root, "pgconCopy_WndSingleCopy", WZUIPageContainer)
    pgconCopy:setTouchEnable(true)
    self.m_bLoadFinish = true 
end

function WndSingleCopy:onActionFinishBack(element, b)
    WZLog("WndSingleCopy:onActionFinishBack")
    local pgconCopy = GetElement(self.m_root, "pgconCopy_WndSingleCopy", WZUIPageContainer)

    self:_setCurrentPageIndex(self.m_nIndex)

    local frontDrawBoxStats = self:getFrontChapterBoxStats()
    if frontDrawBoxStats and self.m_root ~= nil then
        local conTip1 = GetElement(self.m_root,"conTip1_WndSingleCopy",WZUIContainer)
        conTip1:setVisible(true)
    end
    local behineDrawBoxStats = self:getBehindChapterBoxStats()
    if behineDrawBoxStats and self.m_root ~= nil  then
        local conTip2 = GetElement(self.m_root,"conTip2_WndSingleCopy",WZUIContainer)
        conTip2:setVisible(true)
    end

    self:showCellInfo()

    if self.m_root ~= nil then
        WZLog("WndSingleCopy:_pageTurning two")
        if self.m_nIndex == 1 and self.m_luaCell == nil then
            TeachGroup1:startGroup({32,7,WndSingleCopy.m_oPageOne})
        end
    end
end


--@brief  预加载单人副本大地图资源
function WndSingleCopy:_preloadImg()
    WZLog("WndSingleCopy:_preloadImg")
    for i=1,self.m_nCurCopyIndex + 1 do
        local copyData = GDatatab_section["id_"..i]
        if copyData then
           local mapRes = copyData.map_resources
           CCTextureCache:sharedTextureCache():addImage("ui/copy/" .. mapRes)  --如果已有此缓存不会再次添加
        end
    end
end

local CellSingleMap = {}
setmetatable(CellSingleMap, WndSingleCopy)

function CellSingleMap:createElement()
    local element = WZUIContainer:create()
    element:setUseAbsSize(true)
    element:setAbsContentSize(GlobalMethod:CCSize(942,558)) 
    element:setLuaObjectIndex(CellSingleMap)
    return element
end

function CellSingleMap:onEnter(element)
    WZLog("CellSingleMap:onEnter")
end


function CellSingleMap:setData(pageCount,curPageIndex)
    self.m_nPageCount = pageCount
end

function CellSingleMap:onLoadData(element)
    local tag = element:getTag()
    WZLog("CellSingleMap:onLoadData 1 =",tag)
    if tag <= (self.m_nPageCount-1) then
        local cellCopy = WndSingleCopy:_createCellCopy(tag)
        element:addChild(cellCopy)
        for i,v in ipairs(WndSingleCopy.m_tArmatures) do
            v:play("wait",true)
        end

        for i,v in ipairs(WndSingleCopy.m_tEquipArmatures) do
            v:play("wait",true)
        end
        WndSingleCopy.m_tArmatures = {}
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

        local btnPrevious = GetElement(WndSingleCopy.m_root,"btnPrevious_WndSingleCopy",WZUIButton)
        local btnNext = GetElement(WndSingleCopy.m_root,"btnNext_WndSingleCopy",WZUIButton)
        btnPrevious:setTouchEnable(true)
        btnNext:setTouchEnable(true)
        
        for i,v in ipairs(WndSingleCopy.m_tNeedSetFileImg) do
            v:setVisible(true)
        end
        WndSingleCopy:addTreasureBox(element)
        WndSingleCopy:_updateCopyTitle(tag+1,element) 
        if WndSingleCopy.m_nCurPageIndex == tag then
            WndSingleCopy:_updateStarReward(tag+1) --更新星级奖励信息
            WndSingleCopy:_updatePageButton(tag) --更新翻页按钮
            WndSingleCopy.m_bInitFinish = true
            WndSingleCopy:showCellInfo()
        end
       
        --WndSingleCopy.m_nTaskCellId = nil  --任务跳转的章节ID
        WndSingleCopy.m_nJumpPageIndex = nil
        WndSingleCopy.m_oPageCon:setTouchEnable(true)

        --创建章节列表
        WndSingleCopy:_createSectionList(cellCopy)
    end
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
function WndSingleCopy:_loadMapPage(element,delay)
    WZLog("WndSingleCopy:_loadMapPage")
    if not self.m_root then
        return
    end
    CellSingleMap:setData(self.m_createPageCount)
    element:disableSchedule()
    for i=1,self.m_createPageCount do
        local cellMap = CellSingleMap:createElement()
        self.m_oPageCon:setPageElement(i-1,cellMap)
    end
    local curPageIndex = nil
    if SceneCopy.m_bTaskJump or self.m_nJumpPageIndex ~= nil then
        local pageIndex = nil
        if self.m_nJumpPageIndex ~= nil and self.m_nJumpPageIndex > 0 then
            pageIndex = self.m_nJumpPageIndex - 1
        else
            pageIndex = self.m_nCurCopyIndex-1
        end
        -- if pageIndex > 10 then
        --     pageIndex = 0
        -- end
        curPageIndex = pageIndex
        self.m_nCurPageIndex = curPageIndex
        self.m_oPageCon:setDefaultCenterPage(curPageIndex)
    else
        if GlobalGame.g_nSingleMapPage ~= nil and GlobalGame.g_nSingleMapPage ~= -1 and self.m_nCopyType == 1 then
            self.m_nCurPageIndex = GlobalGame.g_nSingleMapPage
            self.m_oPageCon:setDefaultCenterPage(GlobalGame.g_nSingleMapPage)
        elseif GlobalGame.g_nEliteSingleMapPage ~= nil and GlobalGame.g_nEliteSingleMapPage ~= -1 and self.m_nCopyType == 2 then
            self.m_nCurPageIndex = GlobalGame.g_nEliteSingleMapPage
            self.m_oPageCon:setDefaultCenterPage(GlobalGame.g_nEliteSingleMapPage)
        else
            self.m_nCurPageIndex = self.m_nCurCopyIndex-1
            self.m_oPageCon:setDefaultCenterPage(self.m_nCurCopyIndex-1)
        end
    end
    local frontDrawBoxStats = self:getFrontChapterBoxStats()
    if frontDrawBoxStats then
        local conTip1 = GetElement(self.m_root,"conTip1_WndSingleCopy",WZUIContainer)
        conTip1:setVisible(true)
    end
    local behineDrawBoxStats = self:getBehindChapterBoxStats()
    if behineDrawBoxStats then
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

    local tSectionData = self.m_tSectionListData[self.m_nCopyType]
    for i = 1, #tSectionData do
        local element, tNewObj = CellSingleCopySectionItem:createElement()
        if element and tNewObj then 
            element:setTag(i - 1)
            tNewObj:setData(tSectionData[i])
            tbSectionList:setCellElement(element)
            if tSectionData[i].section_id == self.m_nCurCopyIndex then 
            --    tNewObj:setSelState(true)
                self.m_tCellSectionSel = tNewObj 
            else
            --    tNewObj:setSelState(false)
            end
            --红点
            -- local nState = 0 
            -- for k = 1, 3 do
            --     nState = self:_getSectionRewardStateByIndex(k, tSectionData[i].section_id - 1, self.m_nCopyType)
            --     if nState == 2 then 
            --         break 
            --     end
            -- end
            -- if nState == 2 then
            --     tNewObj:setReDot(true)
            -- else
            --     tNewObj:setReDot(false)
            -- end
        end
    end

    self:_setSectionListPos(element)
end

--@brief    设置章节列表位置
function WndSingleCopy:_setSectionListPos(element)
    -- body
    local tbSectionList = GetElement(self.m_root, "tbSectionList_WndSingleCopy", WZUITableContainer)
    local cellHeight = 35
    if self.m_nCurCopyIndex > 12 then
        local nCurPositionY = tbSectionList:getMinPosition().y + (self.m_nCurCopyIndex - 12) * cellHeight
        if nCurPositionY > tbSectionList:getMaxPosition().y then 
            nCurPositionY = tbSectionList:getMaxPosition().y
        end
        tbSectionList:getMoveElement():setPositionY(nCurPositionY)
    end
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
-------------------------------------语言适配End--------------------------------------------
