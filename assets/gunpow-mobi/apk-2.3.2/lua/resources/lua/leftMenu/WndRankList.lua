--WndRankList.lua
--@brief	WndRankList的UI模块
--@date		2015/04/22
--@author	hyq
--@note		排行榜


-------------------------------------公有方法模块Begin--------------------------------------
LOAD_NUM = 10 

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndRankList:onEnter(element)
    WZLog("WndRankList:onEnter")
    self.m_root = element
    self:_AdaptationIphoneX()
    AdaptLanguage(self)
    ChangeChatChannel(Chat_Channel_Rank_List)
    --注册协议
    ProtocolProcessorWndRankList:regAll()

    -- if CacheCenter:getPlayerInfo().level >= 30 then
    --     --根据功能开放，添加师德和恩爱榜
    --     if CheckButtonShow(30) then 
    --         table.insert(self.m_tTempItemTag, 22)
    --     end
    --     if CheckButtonShow(8) then 
    --         table.insert(self.m_tTempItemTag, 23)
    --     end

    --     local tTempItem = {}
    --     local tSortIndex = GetRandomNum(10, 20)
    --     for i = 1, #self.m_tTempItemTag do
    --         local tItem = {}
    --         tItem.type = self.m_tTempItemTag[i]
    --         tItem.sortIndex = tSortIndex[i]

    --         table.insert(tTempItem, tItem)
    --     end

    --     table.sort(tTempItem, sortRankListItem)

    --     self.m_tRankListItemTag = {}
    --     self.m_nSendRankType = tTempItem[1].type
    --     self.m_nCurRankType = self.m_nSendRankType
    --     for i = 1, #tTempItem do
    --         table.insert(self.m_tRankListItemTag, tTempItem[i].type)
    --     end
    -- else
--    self.m_nSendRankType = self.m_tRankListItemTag[1]
    self.m_nCurRankType = self.m_nSendRankType
    --根据功能开放，添加师德和恩爱榜
    if CheckButtonShow(30) then 
        table.insert(self.m_tRankListItemTag, 22)
    end
    if CheckButtonShow(8) then 
        table.insert(self.m_tRankListItemTag, 23)
    end
    --end
    

    --15分钟重置一次排行榜的缓存
    self:_retgetRankList()
    --检查数据是否已经在缓存
    self.m_tRankListInfo = CacheCenter:getRankListInfo()
--    self.m_tMyRankListInfo = CacheCenter:getMyRankListInfo()
    self.m_tMyRankListInfo = nil
    self.m_tMyRankListInfo = {}
    if self.m_tRankListInfo == nil then
        --获取时间
        g_nLastGetRankListTime = os.time()
        WZLog("onEnter:self.m_tRankListInfo == nil")
        --发送战力排行榜请求
        ProtocolProcessorWndRankList:send_RANK_GetRankRecord(self.m_nSendRankType)
        --创建加载框
        self:_createLoading()
    else
        WZLog("onEnter:self.m_tRankListInfo ~= nil")
        local VansPlayerID = self:setFamousPlayerId(self.m_tRankListInfo, self.m_nSendRankType)
        if VansPlayerID ~= nil then
            ProtocolProcessorWndRankList:send_PLAYER_GetSimpleInfo(VansPlayerID, self.m_nSendRankType)
            --创建加载框
            self:_createLoading()
        end
    end
    --创建排行榜类型标签
    self:_createFirstItemCell()

    self.m_nIsTeach = false
    local isEndTeach, finishStep = TeachGroup1:isTeachFinish(16)
    WZLog("sortRankListItem:onEnter", isEndTeach, finishStep)
    if isEndTeach ~= true and TeachGroup1:isTeach() and CacheCenter:getPlayerInfo().level == 10 then
        WindowManager:removeTeachShelterLayer()
        WindowManager:addTeachShelterLayer( 999999, 0 )
        WZLog("sortRankListItem:onEnter2")

        self.m_nIsTeach = true
    end
    
end

function sortRankListItem(a, b)
    -- body
    if a.sortIndex ~= b.sortIndex then
        return a.sortIndex < b.sortIndex
    else
        return a.type < b.type
    end
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndRankList:onExit(element)
    GlobalGame:getBtnRedPointEvent():unregListener("btnTask","WndShop")
    GlobalGame:getBtnRedPointEvent():unregListener("btnBag","WndShop")
    self.m_root:disableSchedule()
	self:_unInit()
    --反注册
    ProtocolProcessorWndRankList:unregAll()
    CCArmatureDataManager:sharedArmatureDataManager():removeAll()
end

--@brief	开始触摸回调函数
--@param	element：触发的节点
--@param	pt：按下的位置
function WndRankList:clickBegan(element , pt)
    WZLog("开始触摸clickBegan")

end

--@brief     创建打开窗口动画
function WndRankList:onEnterTransitionDidFinish(element)
    WZLog("WndRankList:onEnterTransitionDidFinish(element)")

    --添加金币
    --玩家金币栏
   self:_addTop()

    local conLeft = GetElement(self.m_root, "conLeftPart", WZUIContainer)
    local conRight = GetElement(self.m_root, "conFamous_WndRankList", WZUIContainer)
    WindowManagerAni:createSwitchTabAction(conLeft,0,false)
    WindowManagerAni:createSwitchTabAction(conRight,1,false)

    self.m_root:enableSchedule("updateRoleAni", 3)
end

function WndRankList:showInterface(nRankType)
    local pWndRankList = WndRankList:createElement()
    if pWndRankList ~= nil then
        self.m_nSendRankType = nRankType or self.m_tRankListItemTag[1]
        WindowManager:addWindow( pWndRankList , WndRankList )
    end
end

function WndRankList:updateRoleAni(element, delta)
    -- body
    local conFamous = GetElement(self.m_root, "conFamous_WndRankList", WZUIContainer)
    local isVisible = conFamous:isVisible()

    if isVisible then
        local tRandomList = GetRandomNum(1, 3)
        if tRandomList ~= nil and tRandomList ~= {} then
            local nRandom = math.floor(tRandomList[1])
            if nRandom <= 0 then 
                nRandom = 1 
            end
            WZLog("***** WndRankList:updateRoleAni *****", nRandom)
            if self.m_tRoleAniList ~= nil and self.m_tRoleAniList ~= {} then
                if self.m_tRoleAniList[nRandom] ~= nil then 
                    self.m_tRoleAniList[nRandom]:changeRoleAni()
                    if self.m_nSendRankType == 23 then
                        if self.m_tWifeAniList ~= nil and self.m_tWifeAniList[nRandom] ~= nil then
                            self.m_tWifeAniList[nRandom]:changeRoleAni()
                        end
                    end
                end
            end
        end
    end
end

function WndRankList:_addTop()
    -- body
    local celElement, tNewObj = CellTopHandle:createElement()
    tNewObj:setTopData("ui/common/common_icon_phbz.png", WndRankList, WndRankList.onColseWnd, true, true, false, "WndRankList")
    self.m_root:addChild(celElement)
end

--@brief    名人堂回调
function WndRankList:onFamous()
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    --列表容器移出动画
    if self.m_nCheckBoxIndex == 1 then
        return
    end
    self.m_nCheckBoxIndex = 1
    -- GetElement(self.m_root, "conCheckBox", WZUIContainer):setTouchEnable(false)
    -- local conList = GetElement(self.m_root,"conList_WndRankList",WZUIContainer)
    -- WindowManagerAni:createSwitchTabAction(conList, 1, true, nil,self, self.onClickFamousCallBack, true)
    self:onClickFamousCallBack()
end

--@brief    名人堂切换回调
function WndRankList:onClickFamousCallBack()
    -- body
    --名人容器移进动画
    self:update()
    GetElement(self.m_root, "conList_WndRankList", WZUIContainer):setVisible(false)
    GetElement(self.m_root, "conFamous_WndRankList", WZUIContainer):setVisible(true)
    GetElement(self.m_root, "rankRightListimgBg", WZUI9Image):setVisible(false)
    -- local conFamous = GetElement(self.m_root,"conFamous_WndRankList",WZUIContainer)
    -- WindowManagerAni:createSwitchTabAction(conFamous,1,false, nil, self, self.onTransFinish, nil)
end

function WndRankList:onTransFinish()
    -- body
    GetElement(self.m_root, "conCheckBox", WZUIContainer):setTouchEnable(true)
end

--@brief    排行榜单回调
function WndRankList:onRankList()
    -- body
    --名人容器移动出动画
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    
    if self.m_nCheckBoxIndex == 2 then
        return
    end
    self.m_nCheckBoxIndex = 2
    -- GetElement(self.m_root, "conCheckBox", WZUIContainer):setTouchEnable(false)
    -- local conFamous = GetElement(self.m_root,"conFamous_WndRankList",WZUIContainer)
    -- WindowManagerAni:createSwitchTabAction(conFamous, 1, true, nil, self, self.onClickRankListCallBack, true)
    self:onClickRankListCallBack()
end

--@brief 排行榜单切换回调
function WndRankList:onClickRankListCallBack()
    -- body
--    self:clearChecked()
    --创建排行榜列表
    if self.m_bIsCreate then
        self:createTenListInfo()
    end
    GetElement(self.m_root, "conFamous_WndRankList", WZUIContainer):setVisible(false)
    GetElement(self.m_root, "rankRightListimgBg", WZUI9Image):setVisible(true)
    GetElement(self.m_root, "conList_WndRankList", WZUIContainer):setVisible(true)
    --列表容器移进动画
    -- local conList = GetElement(self.m_root,"conList_WndRankList",WZUIContainer)
    -- WindowManagerAni:createSwitchTabAction(conList, 1, false, nil, self, self.onTransFinish, nil)
end

--@brief    接收到服务器数据调用
function WndRankList:receivedServerData(_type)
    if self.m_root == nil then return end 
    WZLog("WndRankList接收到服务器数据调用",type(_type),_type)
    if type(_type) ~= 'number' then _type = tonumber(_type) end
    self.m_tRankListInfo = CacheCenter:getRankListInfo()
    self.m_tSendTag[_type] = true --已收到该类型排行榜的数据
    --第一次进入系统时显示战力排行榜
    if self.m_bCreateEnabled then
       WZLog("self.m_bCreateEnabled == true")
       self.m_bCreateEnabled = false

        local VansPlayerID = self:setFamousPlayerId(self.m_tRankListInfo, _type)
        if VansPlayerID ~= nil then
            ProtocolProcessorWndRankList:send_PLAYER_GetSimpleInfo(VansPlayerID, _type)
            return 
        end
        self:_closeLoading()
        
    end
end

--@brief    沒有數據提示
function WndRankList:noDataAtt()
    --body
    if self.m_root == nil then return end 
    self:_closeLoading()
    MsgBoxManager:showTipBox(LocalStrings.RANK_NO_DATA_ATT)
end

function WndRankList:receiveMyRankListData(nType)
    --body
    if self.m_root == nil then return end 
    WZLog("********** WndRankList:receiveMyRankListData **********", nType)
    if type(nType) ~= 'number' then nType = tonumber(nType) end 

    self.m_tMyRankListInfo = CacheCenter:getMyRankListInfo()
    --膜拜许可条件
    self.m_nCanWorship = self.m_tMyRankListInfo[nType].nCanWorship

    self.m_bIsCreate = true
    self:_createRankInfoCell(nType)

    self:_closeLoading()
end

--@brief    当点击排行榜类型标签时调用
function WndRankList:itemCellClicked(nType)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    local bgCommon = GetElement(self.m_root,"bgCommon_WndRankList",WZUI9Image)
    if nType == 56 then
        bgCommon:setFile("ui/common_bg/common_pic_xz.png")
    else 
        bgCommon:setFile("ui/master/master_pic_bg.png")
    end
    self.m_nCurRankType = nType
    -- WZLog("WndRankList:点击排行榜类型标签",nType)
    -- WZLog("是否创建排行榜",self.m_nSendRankType)
    self.m_tMyRankListInfo = nil
    self.m_tMyRankListInfo = {}
    --15分钟重置一次排行榜的缓存
--    self:_retgetRankList()
    if nType ~= self.m_nSendRankType then
        self.m_tRankListInfo = CacheCenter:getRankListInfo()
        -- if self.m_tRankListInfo == nil then
        --     --发送战力排行榜请求
        --     self.m_bCreateEnabled = true
        --     ProtocolProcessorWndRankList:send_RANK_GetRankRecord(nType)
        --     --创建加载框
        --     self:_createLoading()
        --     return 
        -- else
            local tCurTable = self.m_tRankListInfo[nType]
            if tCurTable == nil then
                --发送战力排行榜请求
                self.m_bCreateEnabled = true
                ProtocolProcessorWndRankList:send_RANK_GetRankRecord(nType)
                --创建加载框
                self:_createLoading()
                return 
            end
        -- end
        
        local VansPlayerID = self:setFamousPlayerId(self.m_tRankListInfo, nType)
        if VansPlayerID ~= nil then
            ProtocolProcessorWndRankList:send_PLAYER_GetSimpleInfo(VansPlayerID, nType)
            --创建加载框
            self:_createLoading()
        end
    end
end

--@brief    战力榜添加切换全服按钮
--@brief    点击切换本/全服按钮响应
function WndRankList:onClickSwitchingServers(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    --战力榜本服和全服切换
    if self.m_nSendRankType == 1 then
        self.m_nCurRankType = 59
    elseif self.m_nSendRankType == 59 then
        self.m_nCurRankType = 1
    end
    --宠物榜本服和全服切换
    if self.m_nSendRankType == 3 then
        self.m_nCurRankType = 60
    elseif self.m_nSendRankType == 60 then
        self.m_nCurRankType = 3
    end
    --等级榜本服和全服切换
    if self.m_nSendRankType == 2 then
        self.m_nCurRankType = 61
    elseif self.m_nSendRankType == 61 then
        self.m_nCurRankType = 2
    end
    self:sendRankProtocol(self.m_nCurRankType)

end

--@brief    发送协议获取数据
function WndRankList:sendRankProtocol( nType )
    self.m_tRankListInfo = CacheCenter:getRankListInfo()
    local tCurTable = self.m_tRankListInfo[nType]
    if tCurTable == nil then
        --发送战力排行榜请求
        self.m_bCreateEnabled = true
        ProtocolProcessorWndRankList:send_RANK_GetRankRecord(nType)
        --创建加载框
        self:_createLoading()

        return
    end

    local VansPlayerID = self:setFamousPlayerId(self.m_tRankListInfo, nType)
    if VansPlayerID ~= nil then
        ProtocolProcessorWndRankList:send_PLAYER_GetSimpleInfo(VansPlayerID, nType)
        --创建加载框
        self:_createLoading()

    end
end

--@brief    更新切换本/全服按钮
function WndRankList:_updateSwitchServerBtn()
    local btnSwitchingServers = GetElement(self.m_root,"btnSwitchingServers_WndRankList",WZUIButton)
    if self.m_nSendRankType == 1 or self.m_nSendRankType == 59 or self.m_nSendRankType == 3 or self.m_nSendRankType == 60 or self.m_nSendRankType == 2 or self.m_nSendRankType == 61 then
        btnSwitchingServers:setVisible(true)
    else
        btnSwitchingServers:setVisible(false)
    end

    local txtSwitchingServers = GetElement(self.m_root,"txtSwitchingServers_WndRankList",WZUILabelTTF)
    if self.m_nSendRankType == 1 or self.m_nSendRankType == 3 or self.m_nSendRankType == 2 then
        txtSwitchingServers:setText(LocalStrings.RANK_TIPS_4[1])
    elseif self.m_nSendRankType == 59 or self.m_nSendRankType == 60 or self.m_nSendRankType == 61 then
        txtSwitchingServers:setText(LocalStrings.RANK_TIPS_4[2])
    end

    local txtMember = GetElement(self.m_root,"txtMember_WndRankList",WZUILabelTTF)
    local txtMember1 = GetElement(self.m_root,"txtMember1_WndRankList",WZUILabelTTF)
    local txtReward = GetElement(self.m_root,"txtReward_WndRankList",WZUILabelTTF)
    local txtReward1 = GetElement(self.m_root,"txtReward1_WndRankList",WZUILabelTTF)
    txtMember:setTextKey("")
    txtMember1:setTextKey("")
    txtReward:setTextKey("")
    txtReward1:setTextKey("")
    if self.m_nSendRankType == 1 or self.m_nSendRankType == 3 or self.m_nSendRankType == 2 then
        txtMember:setText(LocalStrings.RANK_TIPS_5[1])
        txtMember1:setText(LocalStrings.RANK_TIPS_5[1])
        txtReward:setText(LocalStrings.RANK_TIPS_5[2])
        txtReward1:setText(LocalStrings.RANK_TIPS_5[2])
    elseif self.m_nSendRankType == 59 or self.m_nSendRankType == 60 or self.m_nSendRankType == 61 then
        txtMember:setText(LocalStrings.RANK_TIPS_5[3])
        txtMember1:setText(LocalStrings.RANK_TIPS_5[3])
        txtReward:setText(LocalStrings.RANK_TIPS_5[4])
        txtReward1:setText(LocalStrings.RANK_TIPS_5[4])
    else
        txtMember:setText(LocalStrings.RANKLIST_ITEM_MRT)
        txtMember1:setText(LocalStrings.RANKLIST_ITEM_MRT)
        txtReward:setText(LocalStrings.RANKLIST_TITLE)
        txtReward1:setText(LocalStrings.RANKLIST_TITLE)
    end
end


--@brief    清除人物选中状态
function WndRankList:clearChecked(pt)
    if self.m_tRoleAniList == nil then return end
    if pt then
        for i=1,#self.m_tRoleAniList do
            if not self.m_tRoleAniList[i]:checkPointInCon(pt) then
                self.m_tRoleAniList[i]:setChecked(false)
            end
        end
        return
    else
        for i=1,#self.m_tRoleAniList do
            self.m_tRoleAniList[i]:setChecked(false)
        end
    end
end

--@brief    获取是否可膜拜
function WndRankList:getCanWorship()
    -- body
    return self.m_nCanWorship
end

function WndRankList:setCanWorship(nCanWorship)
    -- body
    self.m_nCanWorship = nCanWorship
end

--@brief    刷新界面
function WndRankList:update()
    WZLog("********* WndRankList:update **********", self.m_nSendRankType)
    if self.m_bIsDisplayFamous then return end
    self.m_bIsDisplayFamous = true
    --再次创建人物之前，清理掉之前的人物
    self:cleanFamousRole()
    self.m_tRoleAniList = {}
    self.m_tWifeAniList = {}

    local tTempList = self.m_tFamousList

    self.m_nFamousLoadIndex = 1
    self.m_tFamousLoadList = self.m_tFamousList

    local conFamous = GetElement(self.m_root, "conFamous_WndRankList", WZUIContainer)
    conFamous:enableSchedule("onShowFamous")
end

--@brief    动态显示名人堂角色动画
function WndRankList:onShowFamous(element)
    -- body
    if self.m_nSendRankType == 23 then
        local tHasbandsList = {} 
        local tWifeList = {} 
        for k = 1, #self.m_tFamousLoadList do
            if k == 1 or k == 3 or k == 5 then
                table.insert(tHasbandsList, self.m_tFamousLoadList[k])
            else 
                table.insert(tWifeList, self.m_tFamousLoadList[k])
            end
        end
        if self.m_nFamousLoadIndex > #tHasbandsList then
            element:disableSchedule()
            return
        end
        --妻子
        local celElementWife,tCellWife = CellRankSeat:createElement()
        if celElementWife ~= nil and tCellWife ~= nil then 
            celElementWife:setTag(self.m_nFamousLoadIndex*3 + 1)    --从0开始设置Tag值
            self:setRolePosition(celElementWife, tCellWife, self.m_nFamousLoadIndex)
            tCellWife:setRankSeat(tWifeList[self.m_nFamousLoadIndex], self.m_nSendRankType, true, GlobalMethod:ccp(0.78, 0))
            tCellWife:setAnchorPointForNode(0.85)
            tCellWife:setNodeVisible()
            table.insert(self.m_tWifeAniList,tCellWife)
        end 

        --丈夫
        local celElement,tCell = CellRankSeat:createElement()
        if celElement ~= nil and tCell ~= nil then 
            celElement:setTag(self.m_nFamousLoadIndex-1)    --从0开始设置Tag值
            self:setRolePosition(celElement, tCell, self.m_nFamousLoadIndex)
            tCell:setRankSeat(tHasbandsList[self.m_nFamousLoadIndex], self.m_nSendRankType, nil, GlobalMethod:ccp(0.22, 0))
            tCell:setAnchorPointForNode(0.15)
            tCell.m_tParentWnd = self
            table.insert(self.m_tRoleAniList,tCell)
        end 
    else
        if self.m_nFamousLoadIndex > #self.m_tFamousLoadList then
            element:disableSchedule()
            return
        end
        -- WZLog("名人堂数据",Serialize(self.m_tFamousLoadList),self.m_nFamousLoadIndex, self.m_nSendRankType)
        local tipsParentNode = GetElement(self.m_root, "conRankList_WndRankList", WZUIContainer)
        tipsParentNode = WZUIContainer:luaTo(tipsParentNode)
        
        local celElement,tCell = CellRankSeat:createElement()
        if celElement ~= nil and tCell ~= nil then 
            celElement:setTag(self.m_nFamousLoadIndex-1)    --从0开始设置Tag值
            self:setRolePosition(celElement, tCell, self.m_nFamousLoadIndex, self.m_nSendRankType)
            if self.m_nFamousLoadIndex == 3 then
                tCell:setRankSeat(self.m_tFamousLoadList[self.m_nFamousLoadIndex], self.m_nSendRankType, true)
            else
                tCell:setRankSeat(self.m_tFamousLoadList[self.m_nFamousLoadIndex], self.m_nSendRankType)
            end
            tCell:setOtherData(self.m_nSendRankType, self, tipsParentNode)
            table.insert(self.m_tRoleAniList,tCell)
        end 
    end

    self.m_nFamousLoadIndex = self.m_nFamousLoadIndex + 1 
end

--@brief    清除之前排名类的前三名展示
function WndRankList:cleanFamousRole()
    -- body
    GetElement(self.m_root, "conSilver_WndRankList", WZUIContainer):removeAllChildrenWithCleanup(true)
    GetElement(self.m_root, "conGoldMedal_WndRankList", WZUIContainer):removeAllChildrenWithCleanup(true)
    GetElement(self.m_root, "conCopper_WndRankList", WZUIContainer):removeAllChildrenWithCleanup(true)
end

--@brief    设置角色的位置
--@param    element要添加的节点
--@param    positionIndex角色的名次
--@param    nType 排行榜类型
function WndRankList:setRolePosition(element, tCell, positionIndex, nType)
    -- body
    tCell:setMedalType(positionIndex, nType)
    if positionIndex == 1 then
        GetElement(self.m_root, "conGoldMedal_WndRankList", WZUIContainer):addChild(element)
    elseif positionIndex == 2 then
        GetElement(self.m_root, "conSilver_WndRankList", WZUIContainer):addChild(element)
    elseif positionIndex == 3 then
        GetElement(self.m_root, "conCopper_WndRankList", WZUIContainer):addChild(element)
    end
end

--@brief    膜拜信息展现点击回调
function WndRankList:onArrowUpClicked()
    -- body
    WZLog("膜拜信息展现点击回调")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    --加载框
    self:_createLoading()
    ProtocolProcessorWndRankList:send_RANK_GetWorshipLog( )
end

--@brief    膜拜信息缩回按钮回调
function WndRankList:onArrowDownClicked()
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WZLog("************ WndRankList:onArrowDownClicked ***************")
    local conDownInfo = GetElement(self.m_root, "conDownInfo_WndRankList", WZUIContainer)
    conDownInfo:setVisible(true)

    local actionMove = WZUIActionMoveTo:create()
    actionMove:setMoveX(0.5)
    actionMove:setMoveY(0.013)
    actionMove:setDuration(0.2)
    actionMove:setFinishLuaFunction("onRetractionFinish")

    conDownInfo:runUIAction(actionMove)
end

--@brief    膜拜日志缩回动画完成后，切换显示内容
function WndRankList:onRetractionFinish()
    -- body
    WZLog("************ WndRankList:onRetractionFinish ***************")
    GetElement(self.m_root, "conUpInfo_WndRankList", WZUIContainer):setVisible(true)
    GetElement(self.m_root, "conDownInfo_WndRankList", WZUIContainer):setVisible(false)
end

--@brief    膜拜完成，取消红点
function WndRankList:hideRedDot(nResult)
    -- body
    if nResult ~= 1 then return end

    if self.m_tRoleAniList ~= nil and self.m_tRoleAniList ~= {} then
        for i = 1, 3 do
            if self.m_tRoleAniList[i] ~= nil then 
                self.m_tRoleAniList[i]:setRedDot(false)
                if self.m_nSendRankType == 23 then
                    if self.m_tWifeAniList ~= nil and self.m_tWifeAniList[i] ~= nil then
                        self.m_tWifeAniList[i]:setRedDot(false)
                    end
                end
            end
        end
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@note     ======普通函数定义=====

--@brief    刷新膜拜日志列表、
function WndRankList:_updateWorshipLog()
    -- body
    WZLog("************ WndRankList:_updateWorshipLog ***************")
    self:_createWorshipInfoList()
    GetElement(self.m_root, "conUpInfo_WndRankList", WZUIContainer):setVisible(false)
    local conDownInfo = GetElement(self.m_root, "conDownInfo_WndRankList", WZUIContainer)
    conDownInfo:setVisible(true)

    local actionMove = WZUIActionMoveTo:create()
    actionMove:setMoveX(0.5)
    actionMove:setMoveY(0.64)
    actionMove:setDuration(0.2)

    conDownInfo:runUIAction(actionMove)
end
--@brief    创建膜拜日志列表
function WndRankList:_createWorshipInfoList()
    -- body
    WZLog("************ WndRankList:_createWorshipInfoList ***************")
    local conListNode = GetElement(self.m_root, "conListForNote_WndRankList", WZUITableContainer)
    conListNode:cleanTable()

    local nServerTime = SystemTime:getServerTime()
    WZLog("***** nServerTime *****", nServerTime)
    for i = 1, #self.m_tWorshipLogList do
        -- delayRun(conListNode, i/100,function ()
            local tTempLog = self.m_tWorshipLogList[i]
            -- WZLog("******** iiiiii **********", tTempLog.playerName, tTempLog.worshipDate, tTempLog.worshipName)

            local conForText = WZUIContainer:create()
            conForText:setAbsContentSize(GlobalMethod:CCSize(600, 45))
            conForText:setUseAbsSize(true)
            local txtPlayer = WZUILabelTTF:create()
            txtPlayer:setAnchorPoint(GlobalMethod:ccp(0, 0.5))
            txtPlayer:setRelativePosition(GlobalMethod:ccp(0, 0.5))
            txtPlayer:setColor(GlobalMethod:ccc3(255,236,193))
            txtPlayer:setFontSize(22)
            txtPlayer:setText(tTempLog.playerName)

            --膜拜时间信息
            local txtTime = WZUILabelTTF:create()
            txtTime:setAnchorPoint(GlobalMethod:ccp(0, 0.5))
            txtTime:setRelativePosition(GlobalMethod:ccp(1, 0.5))
            txtTime:setColor(GlobalMethod:ccc3(233,166,62))
            txtTime:setFontSize(22)
            local nLeftTime = nServerTime - tTempLog.worshipDate
            local sTimeText = LocalStrings.JUST_NOW
            if nLeftTime < 60 then -- 刚刚
                sTimeText = LocalStrings.JUST_NOW
            elseif nLeftTime < 60 * 60 then -- xx分钟前
                local nMinites = math.floor(nLeftTime / 60)
                sTimeText = string.format(LocalStrings.MINITE_AGO, nMinites)
            elseif nLeftTime < 24 * 60 * 60 then -- xx小时前
                local nHours = math.floor(nLeftTime / (60 * 60))
                sTimeText = string.format(LocalStrings.HOURS_AGO, nHours)
            elseif nLeftTime < 7 * 24 * 60 * 60 then -- xx天前
                local nDays = math.floor(nLeftTime / (24 * 60 * 60))
                sTimeText = string.format(LocalStrings.DAYS_AGO, nDays)
            else -- 很久前
                sTimeText = LocalStrings.LONG_AGO
            end
            
            --膜拜对象信息
            local txtWorshipPlayerInfo = WZUILabelTTF:create()
            txtWorshipPlayerInfo:setAnchorPoint(GlobalMethod:ccp(0, 0.5))
            txtWorshipPlayerInfo:setRelativePosition(GlobalMethod:ccp(1, 0.5))
            txtWorshipPlayerInfo:setColor(GlobalMethod:ccc3(255,236,193))
            txtWorshipPlayerInfo:setFontSize(22)
            txtWorshipPlayerInfo:setText(tTempLog.worshipName)
            

            if ProjConfig.LANGUAGE == "en" then
                local txtWorshiped = WZUILabelTTF:create()
                txtWorshiped:setAnchorPoint(GlobalMethod:ccp(0, 0.5))
                txtWorshiped:setRelativePosition(GlobalMethod:ccp(1, 0.5))
                txtWorshiped:setColor(GlobalMethod:ccc3(233,166,62))
                txtWorshiped:setFontSize(22)
                txtWorshiped:setText(" " .. LocalStrings.XX_WORSHIP_XX .. "  ")

                txtTime:setText(" " .. sTimeText)

                conForText:addChild(txtPlayer)
                txtPlayer:addChild(txtWorshiped)
                txtWorshiped:addChild(txtWorshipPlayerInfo)
                txtWorshipPlayerInfo:addChild(txtTime)
            else
                txtTime:setText(" " .. sTimeText .. LocalStrings.XX_WORSHIP_XX .. " ")

                conForText:addChild(txtPlayer)
                txtPlayer:addChild(txtTime)
                txtTime:addChild(txtWorshipPlayerInfo)
            end

            conForText:setTag(i-1)

            conListNode:setCellElement(conForText)
        -- end)
    end

    conListNode:getMoveElement():setPositionY(conListNode:getMaxPosition().y)

end

--@brief    创建排行榜类型1级标签
function WndRankList:_createFirstItemCell()
    WZLog("创建排行榜类型 1 级标签")
    --获取table控件
    local tbconRankListItem = WZUITableContainer:luaTo(self.m_root:getChildElement("table_rankListItem_left"))
    if tbconRankListItem == nil then return end
    self.m_tLeftList = {}
    for i,v in ipairs(self.m_tRankListItemTag) do
        WZLog("************** item===i: ************** ",i,v)
        --创建cell
        local cellElement,tCell = CellRankListItem:createElement()
        self.m_tLeftList[tonumber(v)] = tCell
        --设置Cell标志
        cellElement:setTag(i-1)
        --Cell添加到table
        tbconRankListItem:setCellElement(cellElement)
        --一进来默认选中第一个
        if v == self.m_nSendRankType then 
            tCell:setSelSignVisible(true)
        end
        --初始化Cell
        tCell:initCellData(v)
    end
end

--@brief    设置前一选中的榜类的选中状态为不可见
function WndRankList:_setSelSignVisible(bBool, nType)
    -- body
    if self.m_tLeftList == nil then return end

    --战力榜特殊处理 
    if nType == 1 or nType == 59 then
        nType = 1
    end
    --宠物榜特殊处理 
    if nType == 3 or nType == 60 then
        nType = 3
    end
    --等级榜特殊处理 
    if nType == 2 or nType == 61 then
        nType = 2
    end

    if bBool == true then
        if self.m_sTouchLeftTitle then
            self.m_sTouchLeftTitle:normalTitleLabel()
        end
    end
    local tNewObj = self.m_tLeftList[nType]
    tNewObj:setSelSignVisible(bBool)
    self.m_sTouchLeftTitle = tNewObj

    if bBool == true then
        tNewObj:selectTitleLabel()
    end
end

--@brief    创建排行榜信息Cell
function WndRankList:_createRankInfoCell(_rankType)
    WZLog("WndRankList:_createRankInfoCell",self.m_nSendRankType,_rankType)
    -- WZLog("创建排行榜信息Cell",_rankType,Serialize(self.m_tRankListInfo))
    self.m_bIsDisplayFamous = false
    if self.m_tRankListInfo == nil then  return end
    local rankType = _rankType
    local infotable = self.m_tRankListInfo[rankType] --rankType对应的table
    if infotable == nil then
        self.m_bCreateEnabled = true
        ProtocolProcessorWndRankList:send_RANK_GetRankRecord(rankType)
        --创建加载框
        self:_createLoading()
        return
    end

    if self.m_tMyRankListInfo == nil then 
        self.m_tMyRankListInfo = {}
    end
    local myRankInfoTable = self.m_tMyRankListInfo[rankType]
    if myRankInfoTable == nil then
        ProtocolProcessorWndRankList:send_RANK_GetPlayerRank(rankType)
        --创建加载框
        self:_createLoading()

        return
    end
    --将原选中的标签项高亮隐藏
    self:_setSelSignVisible(false, self.m_nSendRankType)
    --更新请求类型
    self.m_nSendRankType = rankType
    --将现选中的标签项高亮设为可见
    self:_setSelSignVisible(true, self.m_nSendRankType)
    --更新切换本/全服按钮
    self:_updateSwitchServerBtn()
    --名人堂前三展示
    if self.m_nCheckBoxIndex == 1 then
        self:update() 
    end
    --更新标签
    self:_updateInfoItemLabel(rankType)
    --获取table控件
    local tbconRankListInfo = WZUITableContainer:luaTo(self.m_root:getChildElement("table_rankListInfo_right"))
    if tbconRankListInfo == nil then
        WZLog("tbconRankListInfo==nil")
        return
    end
    --首先清空table
    local cellNum = tbconRankListInfo:getColumnCount()
    WZLog("cellNum1===",cellNum)
    if cellNum ~= 0 then
        tbconRankListInfo:cleanTable()
        WZLog("cellNum2===",tbconRankListInfo:getColumnCount())
    end

    --创建cell
    if self.m_nCheckBoxIndex == 2 then
        self:createTenListInfo()
        tbconRankListInfo:getMoveElement():setPositionY(tbconRankListInfo:getMinPosition().y)
    end
end

--@brief    每次创建10个表项
function WndRankList:createTenListInfo()
    -- body
    WZLog("********* WndRankList:createTenListInfo **************")
    local tbconRankListInfo = WZUITableContainer:luaTo(self.m_root:getChildElement("table_rankListInfo_right"))
    local rankType = self.m_nSendRankType
    if self.m_tRankListInfo == nil then return end 
    local infoTable = self.m_tRankListInfo[rankType] --rankType对应的table
    if infoTable == nil or #infoTable == 0 then return end
    
    self.m_nCurNeedLoadNum = #infoTable
    self.m_nCurIndex = 0
    self.m_nCurLoadIndex = 1
    self.m_bIsCreate = false
    self:onShowList(tbconRankListInfo)
end

--@brief    创建排行列表
function WndRankList:onShowList(element, delta)
    -- body
    local rankType = self.m_nSendRankType
    local infoTable = self.m_tRankListInfo[rankType] --rankType对应的table
    if infoTable == nil or #infoTable == 0 then 
        element:disableSchedule()
        return 
    end
    WZLog("创建排行列表",rankType)
    element = WZUITableContainer:luaTo(element)

    for i = 1, #infoTable do
        local t = infoTable[self.m_nCurLoadIndex]
        if t == nil then return end
        local ntag = self.m_nCurLoadIndex-1
        --创建cell
        local cellElement
        local tCell 
        if rankType == 1 or rankType == 59 or rankType == 3 or rankType == 60 then
            cellElement, tCell= CellRankFighting:createElement()
        elseif rankType == 2 or rankType == 61 or rankType == 13 or rankType == 56 then
            cellElement, tCell= CellRankLevel:createElement()
        elseif rankType == 12 or rankType == 22 then
            cellElement, tCell= CellRankAthletics:createElement()
        else
            cellElement, tCell= CellRankListInfo:createElement()
        end
        --设置Cell标志
        cellElement:setTag(ntag)
        --Cell添加到table
        element:setCellElement(cellElement)
        --初始化cell
        tCell:setData(t.ranking, t.playerId, t.name, t.faceId, t.headId, t.sex, t.level, t.param1, t.param2, t.param3, t.param4, t.param5, t.param6, t.param7, rankType, t.trendRank, t.vipLevel, t.param8, t.headColor, t.param9, t.headEffectId, t.wifeHeadEffectId, t.qqHallData)

        self.m_nCurLoadIndex = self.m_nCurLoadIndex + 1
    end
    
end

--@brief    更新标签
function WndRankList:_updateInfoItemLabel(_rankType)
    WZLog("更新标签WndRankList:_updateInfoItemLabel",_rankType)
    local conInfoItem_four = GetElement(self.m_root, "conItemLabel_four", WZUIContainer)
    local conInfoItem_five = GetElement(self.m_root, "conItemLabel_five", WZUIContainer)
    if conInfoItem_four == nil or conInfoItem_five == nil  then return end
    -- if _rankType == 55 then _rankType = _rankType + 1 end

    self:_updateMyRank(_rankType)
    --战力榜特殊处理 59为全服战力榜
    if _rankType == 59 then
        _rankType = 1
    end
    --战力榜特殊处理 60为全服宠物榜
    if _rankType == 60 then
        _rankType = 3
    end
    --等级榜特殊处理 61为全服等级榜
    if _rankType == 61 then
        _rankType = 2
    end

    local t = self.m_tRankTypeInfoName[_rankType]
    local itemNum = #t --包含标签个数
    if t == nil then return end
    local n1 = t[1]
    local n2 = t[2]
    local n3 = t[3]
    local n4 = t[4]
    local n5 = t[5]

    local conInfoItem_four = GetElement(self.m_root, "conItemLabel_four", WZUIContainer)
    local conInfoItem_five = GetElement(self.m_root, "conItemLabel_five", WZUIContainer)
    if itemNum == 5 then
        conInfoItem_five:setVisible(true)
        conInfoItem_four:setVisible(false)
        
        GetElement(self.m_root, "item_label_1_five", WZUILabelTTF):setText(self.m_tInfoItemName[n1])
        GetElement(self.m_root, "item_label_2_five", WZUILabelTTF):setText(self.m_tInfoItemName[n2])
        GetElement(self.m_root, "item_label_3_five", WZUILabelTTF):setText(self.m_tInfoItemName[n3])
        GetElement(self.m_root, "item_label_4_five", WZUILabelTTF):setText(self.m_tInfoItemName[n4])
        GetElement(self.m_root, "item_label_5_five", WZUILabelTTF):setText(self.m_tInfoItemName[n5])
    else
        conInfoItem_five:setVisible(false)
        conInfoItem_four:setVisible(true)
        
        GetElement(self.m_root, "item_label_1_four", WZUILabelTTF):setText(self.m_tInfoItemName[n1])
        GetElement(self.m_root, "item_label_2_four", WZUILabelTTF):setText(self.m_tInfoItemName[n2])
        GetElement(self.m_root, "item_label_3_four", WZUILabelTTF):setText(self.m_tInfoItemName[n3])
        GetElement(self.m_root, "item_label_4_four", WZUILabelTTF):setText(self.m_tInfoItemName[n4])
    end
end

--@brief    设置展示我的排名
function WndRankList:_updateMyRank(_rankType)
    -- body
    local txtMyRank = GetElement(self.m_root, "label_player_info", WZUILabelTTF)
    WZLog("展示我的排名",_rankType)
    -- if _rankType == 56 then _rankType = _rankType - 1 end
    local tTempMy = self.m_tMyRankListInfo[_rankType]
    local nMyRank = tTempMy.myRank
    local nRankNum = tTempMy.rankValue
    local nRankExp = tTempMy.rankExp
    local nTrendRank = tTempMy.myTrendRank --排名不变
    --我的排名：
    GetElement(self.m_root, "txtMyRankWord_WndRankList", WZUILabelTTF):setText(LocalStrings.KING_RANK_MY_RANK)
    --显示尚未登榜提示
    if nMyRank == -1 then
        txtMyRank:setText(LocalStrings.NOT_IN_RANKLIST)
    else
        txtMyRank:setText(tostring(nMyRank))
    end

    local txtValueProperty = tostring(nRankNum)
    local txtLevel = GetElement(self.m_root,"txtModelLevel_WndRankList",WZUILabelTTF)
    txtLevel:setVisible(false)


    --显示我的排名的浮动标记
    if nTrendRank == 1 and nMyRank ~= 0 then     --排名上升
        GetElement(self.m_root, "imgRiseIcon_WndRankList", WZUIImage):setVisible(true)
        GetElement(self.m_root, "imgDropIcon_WndRankList", WZUIImage):setVisible(false)
    elseif nTrendRank == 2 and nMyRank ~= 0 then     --排名下降
        GetElement(self.m_root, "imgRiseIcon_WndRankList", WZUIImage):setVisible(false)
        GetElement(self.m_root, "imgDropIcon_WndRankList", WZUIImage):setVisible(true)
    end
    --我的排名的图标
    local imgValueIcon = GetElement(self.m_root, "imgValueIcon_WndRankList", WZUIImage)
    local txtMyRankLv = GetElement(self.m_root, "txtMyRankLv_WndRankList", WZUILabelAtlasFont)
    local txtProperty = GetElement(self.m_root, "txtValueProperty_WndRankList", WZUILabelTTF)
    local txtValueName = GetElement(self.m_root, "txtValueName_WndRankList", WZUILabelTTF)
    imgValueIcon:setVisible(false)
    imgValueIcon:setScale(1)
    txtMyRankLv:setVisible(false)
    txtProperty:setRelativePosition(GlobalMethod:ccp(0.859, 0.5))
    txtValueName:setRelativePosition(GlobalMethod:ccp(0.85,0.5))
    -- txtProperty:setColor(GlobalMethod:ccc3(255,236,193))
    --我的排名信息
    WZLog("WndRankList:_updateMyRank",_rankType)
    local sPropertyWord
    if _rankType == 1 or _rankType == 59 then      --战力榜
        sPropertyWord = LocalStrings.BATTLE
        -- txtProperty:setColor(GlobalMethod:ccc3(255,89,74))
    elseif _rankType == 56 then
        sPropertyWord = LocalStrings.SCORE_MEDAL
        local lv = 1
        for i = 1,30 do
            if tonumber(GDatatab_vip_medal_level["id_"..i].point) > tonumber(nRankNum) then
                lv = GDatatab_vip_medal_level["id_"..i].level 
                break
            elseif tonumber(GDatatab_vip_medal_level["id_"..i].point) == tonumber(nRankNum) then
                lv = GDatatab_vip_medal_level["id_"..i].level + 1
                break
            elseif tonumber(GDatatab_vip_medal_level["id_"..i].point) < tonumber(nRankNum) then
                lv = GDatatab_vip_medal_level["id_"..i].level
            end
        end
        txtLevel:setText(LocalStrings.NEWVIP_TEXT16..":"..lv)
        txtLevel:setVisible(true)
    elseif _rankType == 2 or _rankType == 61 then      --等级榜
        sPropertyWord = LocalStrings.LEVEL
    elseif _rankType == 3 or _rankType == 60 then      --宠物榜
         sPropertyWord = LocalStrings.MY_PETS
        if CacheCenter:getPlayerInfo().petMessage ~= nil and CacheCenter:getPlayerInfo().petMessage ~= "" then
            petMessage = json.decode(CacheCenter:getPlayerInfo().petMessage)
            local petLevel = petMessage.upgradeLevel
            local petName = petMessage.name
            txtValueProperty = "Lv" .. tostring(petLevel) .. " " .. petName
        else
            txtValueProperty = "(" .. LocalStrings.NONE .. ")"
        end
        txtProperty:setRelativePosition(GlobalMethod:ccp(0.8, 0.5))
        txtValueName:setRelativePosition(GlobalMethod:ccp(0.79,0.5))

        if ProjConfig.LANGUAGE == "vn" then
            txtProperty:setRelativePosition(GlobalMethod:ccp(0.71, 0.5))
            txtValueName:setRelativePosition(GlobalMethod:ccp(0.7,0.5))
        end
    elseif _rankType == 12 then     --竞技榜
        sPropertyWord = LocalStrings.COMPETIVITY_LEVEL
        imgValueIcon:setVisible(true)
        imgValueIcon:setScale(0.5)
        local tCurLevelTable = self:_getIntegralName(nRankNum)
        imgValueIcon:setFile("ui/common/" .. tCurLevelTable.iocn .. ".png")
        txtProperty:setRelativePosition(GlobalMethod:ccp(0.89, 0.5))
        txtValueProperty = tCurLevelTable.dan
        --等级
        local nPartLevel = tCurLevelTable.iocn_level
        txtMyRankLv:setVisible(false)
        txtMyRankLv:setText(tostring(nPartLevel))
    elseif _rankType == 13 then     --成就榜
        sPropertyWord = LocalStrings.ACHIE_NUMBER
    elseif _rankType == 22 then     --师德榜
        sPropertyWord = LocalStrings.TEACHER_LEVEL
        txtMyRankLv:setVisible(false)
    elseif _rankType == 23 then     --恩爱榜
        sPropertyWord = LocalStrings.LOVING_LEVEL
        imgValueIcon:setVisible(true)
        imgValueIcon:setScale(0.35)
        imgValueIcon:setFile("ui/common/common_icon_enai1.png")
        txtProperty:setRelativePosition(GlobalMethod:ccp(0.8, 0.5))
        --恩爱值
        txtValueProperty = tostring(nRankExp)
        --等级
        txtMyRankLv:setVisible(false)
        txtMyRankLv:setText(tostring(nRankNum))
        if ProjConfig.LANGUAGE == "vn" then
            -- txtProperty:setRelativePosition(GlobalMethod:ccp(0.9, 0.5))
            txtValueName:setRelativePosition(GlobalMethod:ccp(0.8,0.5))
        end
    end
    txtValueName:setText(sPropertyWord .. ": ")
    txtProperty:setText(txtValueProperty)
end

function WndRankList:_getIntegralName(level)
    -- body
    WZLog("*********** WndRankList:_getIntegralName ***********", level)
    if level == 0 or level == nil then
        level = 1
    end

    local tCurTable = GDatatab_integral[string.format("id_%d", level)]
    if tCurTable == nil then
        local nTableNum = 0
        for k, v in pairs(GDatatab_integral) do
            nTableNum = nTableNum + 1
        end
        WZLog("*********** WndRankList:_getIntegralName 111***********", nTableNum)
        tCurTable = GDatatab_integral[string.format("id_%d", nTableNum)]
    end
    
    --local sIntegralName = ""
    -- for k, v in pairs(GDatatab_integral) do
    --     if v.level == level then
    --         sIntegralName = v.dan
    --         break 
    --     end
    -- end

    return tCurTable
end
--@brief    创建加载框
function WndRankList:_createLoading()
    self.m_nLoadingId = MsgBoxManager:showLoadingBox()
end
--@brief   关闭加载框
function WndRankList:_closeLoading()
    local nId = self.m_nLoadingId
    MsgBoxManager:stopLoadingBoxByMsgId(nId)
end

--@note     ======回调函数定义=====

--@brief	窗口动画完成回调
function WndRankList:openWndActionCallback(elem,data)
    WZLog("WndRankList:openWndActionCallback(elem,data)")

end

--@brief    点击关闭按钮时被调用的函数
--@note     关闭系统窗口
function WndRankList:onColseWnd(element)
    WZLog("单击关闭按钮")
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    PostPlayerEvent:postEvent(PostPlayerEvent.event_tenLvClickBack)
    --排行榜单移出
    WindowManagerAni:createSwitchTabAction(GetElement(self.m_root,"conList_WndRankList",WZUIContainer), 1, true, nil, nil, nil, true)

     --左右容器移动动画
    local rightCon = GetElement(self.m_root,"conFamous_WndRankList",WZUIContainer)
    WindowManagerAni:createSwitchTabAction(rightCon,1,true,nil,nil,nil,true)
    
    local leftCon = GetElement(self.m_root,"conLeftPart",WZUIContainer)
    WindowManagerAni:createSwitchTabAction(leftCon,0,true,nil,self,self.onCloseActionCallback_WndRankList,true)
end
--@brief	窗口动画关闭完成回调
function WndRankList:onCloseActionCallback_WndRankList(elem,data)
    WindowManager:removeWindow(self.m_root , WndRankList , true)

    --东南亚渠道:1009,1016,1046,1038 
    --完成10级新手引导后弹出首冲  
    local tabChannel = {1009,1016,1046,1038}
    for _,v in ipairs(tabChannel) do
        if ProjConfig.CHANNEL_ID == v then
            if self.m_nIsTeach == true then
                CellRechargePanelActivity:show()
            end
        end
    end

end

--@brief    点击界面
function WndRankList:onTouchBegan(element, pt)
    WZLog("*********** WndRankList:onTouchBegan *************")
    if not WndTips:checkPointInBtn(pt) then
        WndTips:onCloseClick()
    end
    local conDownInfo = GetElement(self.m_root, "conDownInfo_WndRankList", WZUIContainer)
    local bIsVisible = conDownInfo:isVisible()
    WZLog("WndRankList:onTouchBegan",bIsVisible,self:checkPointInCon(pt))
    if bIsVisible and not self:checkPointInCon(pt) then
        self:onArrowDownClicked()
    end

    if WndItemInfo.m_root then
        WndItemInfo:onCloseClick()
    end

    self:clearChecked(pt)
end

--@brief    点击界面
function WndRankList:onTouchEnd()
    WZLog("*********** WndRankList:onTouchEnd *************")
    
end

--@brief    检查坐标点是否在VIP按钮范围内
--@param    pt:鼠标点击的世界坐标
--@return   在按钮范围内返回true,否则返回false
function WndRankList:checkPointInCon(pt)
    WZLog("WndRankList:checkPointInCon",pt.x,pt.y)
    if self.m_root == nil then return end
    local con = GetElement(self.m_root, "conDownInfo_WndRankList", WZUIContainer)
    if con == nil then return false end
    local conSize = con:getAbsContentSize()
    --获得con的世界坐标
    local ptA = con:convertToWorldSpace(GlobalMethod:ccp(0,0))
    WZLog("con 世界坐标",ptA.x,ptA.y)
    WZLog("按钮大小",conSize.width,conSize.height)
    if (pt.x > ptA.x and pt.x < ptA.x + conSize.width) and (pt.y > ptA.y and pt.y < ptA.y + conSize.height) then
        WZLog("点击在按钮范围内")
        return true
    else
        WZLog("点击在按钮范围外")
        return false
    end 
end
-------------------------------------私有方法模块End----------------------------------------
--------------------------------语言适配Begin------------------------------------
function WndRankList:_adaptLanguage_pt(  )
    local txt1 = GetElement(self.m_root,"txtMyRankWord_WndRankList",WZUILabelTTF)
    txt1:setFontSize(16)
    txt1:setRelativePosition(GlobalMethod:ccp(0.2,0.5))
    local txt2 = GetElement(self.m_root,"label_player_info",WZUILabelTTF)
    txt2:setFontSize(16)
    txt2:setRelativePosition(GlobalMethod:ccp(0.2,0.5))
    GetElement(self.m_root,"txtValueName_WndRankList",WZUILabelTTF):setFontSize(16)
    GetElement(self.m_root,"txtValueProperty_WndRankList",WZUILabelTTF):setFontSize(16)
end

function WndRankList:_adaptLanguage_tr(  )
    local txt1 = GetElement(self.m_root,"txtMyRankWord_WndRankList",WZUILabelTTF)
    txt1:setFontSize(16)
    txt1:setRelativePosition(GlobalMethod:ccp(0.2,0.5))
    local txt2 = GetElement(self.m_root,"label_player_info",WZUILabelTTF)
    txt2:setFontSize(16)
    txt2:setRelativePosition(GlobalMethod:ccp(0.2,0.5))
    GetElement(self.m_root,"txtValueName_WndRankList",WZUILabelTTF):setFontSize(16)
    GetElement(self.m_root,"txtValueProperty_WndRankList",WZUILabelTTF):setFontSize(16)
end

function WndRankList:_adaptLanguage_es(  )
    local txt1 = GetElement(self.m_root,"txtMyRankWord_WndRankList",WZUILabelTTF)
    txt1:setFontSize(18)
    txt1:setRelativePosition(GlobalMethod:ccp(0.2,0.5))
    local txt2 = GetElement(self.m_root,"label_player_info",WZUILabelTTF)
    txt2:setFontSize(18)
    txt2:setRelativePosition(GlobalMethod:ccp(0.2,0.5))
    GetElement(self.m_root,"txtValueName_WndRankList",WZUILabelTTF):setFontSize(18)
    GetElement(self.m_root,"txtValueProperty_WndRankList",WZUILabelTTF):setFontSize(18)
end

function WndRankList:_adaptLanguage_vn(  )
    GetElement(self.m_root,"txtMember_WndRankList",WZUILabelTTF):setFontSize(16)
    GetElement(self.m_root,"txtMember1_WndRankList",WZUILabelTTF):setFontSize(16)
    GetElement(self.m_root,"txtReward_WndRankList",WZUILabelTTF):setFontSize(16)
    GetElement(self.m_root,"txtReward1_WndRankList",WZUILabelTTF):setFontSize(16)
end


--适配iphoneX
function WndRankList:_AdaptationIphoneX()
    -- body
    WZLog("WndRankList:_AdaptationIphoneX")
    if true then
        local conLeftPart = GetElement(self.m_root,"conLeftPart",WZUIContainer)
        conLeftPart:setAbsContentSize(GlobalMethod:CCSize(300,570))
        conLeftPart:updateRelativeSize()
    end
end

----------------------------------语言适配End-------------------------------------