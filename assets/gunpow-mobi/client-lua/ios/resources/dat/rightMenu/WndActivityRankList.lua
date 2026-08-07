--WndActivityRankList.lua
--@brief	WndActivityRankList的UI模块
--@date		2016/07/11
--@author	Tianxiang_Xu
--@note		活动夫妻战和工会战排行榜


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndActivityRankList:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndActivityRankList:onExit(element)
	self:_unInit()
end

--@brief    界面加载完成后回调
function WndActivityRankList:onEnterTransitionDidFinish(element)
    -- body
    WindowManagerAni:createAppearAction(self.m_root, true, "openCallBack", self)
end

--@brief    打开界面动画完成后回调
function WndActivityRankList:openCallBack()
    -- body
    self:_setStaticText()

    self:_createLoading()
    ProtocolProcessorWndActivityOnLine:send_ACTIVITY_RankList(self.m_nRankType)
end

--@brief    点击关闭按钮回调
function WndActivityRankList:onClose(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

    WindowManagerAni:createDisappearAction(self.m_root, "closeCallBack", self)
end

--@brief    关闭动画完成后回调
function WndActivityRankList:closeCallBack()
    -- body
    WindowManager:removeWindow(self.m_root, self, true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief   创建加载框
function WndActivityRankList:_createLoading()
    self.m_nLoadingId = MsgBoxManager:showLoadingBox()
end

--@brief   关闭加载框
function WndActivityRankList:_closeLoading()
    local nId = self.m_nLoadingId
    MsgBoxManager:stopLoadingBoxByMsgId( nId )
end

--@brief    设置静态文本的内容
function WndActivityRankList:_setStaticText()
    -- body
    local txtWinwords = GetElement(self.m_root, "txtWinwords_WndActivityRankList", WZUILabelTTF)
    txtWinwords:setText(LocalStrings.ACTIVITY_WINWORDS .. ":")
    --榜单顶部标签
    local tLabelIndex = self.m_tRankTypeInfoName[self.m_nRankType]
    WZLog("WndActivityRankList:_setStaticText", self.m_nRankType, #tLabelIndex)
    for i = 1, #tLabelIndex do
        local txtLabel1 = GetElement(self.m_root, string.format("txtLabel%d_WndActivityRankList", i), WZUILabelTTF)
        txtLabel1:setText(self.m_tInfoItemName[tLabelIndex[i]])
    end
    
end

--@brief    更新界面
function WndActivityRankList:_update()
    --body
    --我赢的场数
    local txtWinNum = GetElement(self.m_root, "txtWinNum_WndActivityRankList", WZUILabelTTF)
    if self.m_nMyWinCount <= 0 then
        txtWinNum:setText(0)
    else
        txtWinNum:setText(self.m_nMyWinCount)
    end
    --我的排名
    local txtRank = GetElement(self.m_root, "txtRank_WndActivityRankList", WZUILabelTTF)
    if self.m_nMyRank <= 0 then
        txtRank:setText(LocalStrings.NOT_IN_RANKLIST)
    else
        txtRank:setText(self.m_nMyRank)
    end

    local tbconList = GetElement(self.m_root, "tbconList_WndActivityRankList", WZUITableContainer)
    tbconList:cleanTable()
    local conCenter = GetElement(self.m_root, "conCenter_WndActivityRankList", WZUIContainer)
    if self.m_tRankListData == nil or #self.m_tRankListData == 0 then
        WZLog("WndActivityRankList:_update", conCenter)
        ShowPanelNullTip(conCenter)
        return 
    end

    removeShowPanelNullTip(conCenter)

    for i = 1, #self.m_tRankListData do
        local t = self.m_tRankListData[i]
        local cellElement, tCell = CellActivityRankList:createElement()
        --设置Cell标志
        cellElement:setTag(i - 1)
        --Cell添加到table
        tbconList:setCellElement(cellElement)
        --初始化cell
        tCell:setData(t.ranking, t.playerId, t.name, t.faceId, t.headId, t.sex, t.level, t.param1, t.param2, t.param3, t.param5, t.param6, t.param7, self.m_nRankType, t.vipLevel, t.winCount, t.guildName, t.headColor, t.param8)
    --    tCell:setData(i, 1977117, "我却是很好啊", 4305, 4206, 0, 30, 1977117, "我不是很好啊", "35", 4307, 4209, 2, 1004, 3, 60, "不是太牛逼的公会")
    end
end

-------------------------------------私有方法模块End----------------------------------------
