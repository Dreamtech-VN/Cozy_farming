--WndPvpRankList.lua
--@brief	WndPvpRankList的UI模块
--@date		2016-3-30
--@author	binshao
--@note		排位赛赛季奖励


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndPvpRankList:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)
end

----@brief onEnter函数执行完成回调
function WndPvpRankList:onEnterTransitionDidFinish(element)
    WindowManagerAni:createAction(self.m_root, true, "actionCallback", self)
end

----@brief    弹窗动画完成后的回调
function WndPvpRankList:actionCallback(element, data)

end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndPvpRankList:onExit(element)
	self:_unInit()
end

--@brief	点击关闭按钮时被调用的函数
--@param	element:按钮绑定的UI节点引用
function WndPvpRankList:OnClose(element)
    WZLog("WndPvpRankList:onClose")
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	WindowManagerAni:createCloseAction(self.m_root, "onActionCallBack", self)
end

--@brief	动画播完后的回调
function WndPvpRankList:onActionCallBack()
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief   弹框TIPS
function WndPvpRankList:OnTouchBegin(element,pt)
    WndItemInfo:onCloseClick()
end

--@brief	点击单元格时的回调
--@param    nTag,被点击单元格的tag值
--@param    tCell,被点击单元格绑定的lua表对象
function WndPvpRankList:onClickCell(nTag, tCell)
end

function WndPvpRankList:onClickRewardItem(luaObject,data)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndItemInfo:showInfo(luaObject.m_root,self.m_root,1,data,false)
end

--@brief	点击查看资料按钮时的回调
--@param    element,按钮绑定的UI节点引用
function WndPvpRankList:onLook(element)
    WZLog("WndPvpRankList:onLook", self.m_nSelCellIndex)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
end

-- 排行
function WndPvpRankList:onMatchGoal()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    self:setCheckBoxAndCon(1)
    self:createMatchGoal()
end

--奖励
function WndPvpRankList:onMatchReward()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    self:setCheckBoxAndCon(2)
    self:createMatchReward()
end

-- 显示UI
function WndPvpRankList:showWndUI(tag, tData)
    local wnd = WndPvpRankList:createElement()
    WindowManager:addWindow(wnd,WndPvpRankList)
    self.m_tData = tData 
    self:setCheckBoxAndCon(tag)
    if tag == 1 then
        self:createMatchGoal()
    elseif tag == 2 then
        self:createMatchReward()
    end
end
-------------------------------------公有方法模块End----------------------------------------

-------------------------------------私有方法模块Begin--------------------------------------

-- 玩家赛季排名
function WndPvpRankList:createMatchGoal()
    if not self.matchGoal then
        ProtocolProcessorScenePvpRank:send_TRIO_GetMathcRank( )
    else
        local tbRankList = GetElement(self.m_root,"tbRankList_WndPvpRankList",WZUITableContainer)
        tbRankList:cleanTable()
        local sContent = string.format(LocalStrings.MY_PVPRANK, tostring(self.m_nMyRank))
        if self.m_nMyRank == -1 then
            sContent = string.format(LocalStrings.MY_PVPRANK, LocalStrings.NOT_IN_RANKLIST)
        end
        local ftxtMyRank = GetElement(self.m_root,"ftxtMyRank_WndPvpRankList",WZUIFreeTextBox)
        ftxtMyRank:setShowText(sContent)
        local conRank = GetElement(self.m_root, "conRank_WndPvpRankList", WZUIContainer)
        if #self.matchGoal == 0 then 
            ShowPanelNullTip(conRank)
            return 
        end
        removeShowPanelNullTip(conRank)

        for i = 1, #self.matchGoal do
            local cell,tcell = CellPvpRankItem:createElement()
            cell:setTag(i-1)
            tbRankList:setCellElement(cell)
            tcell:setData(self.matchGoal[i])
			-- if ProjConfig.LANGUAGE == "en" then
			-- 	txt:setText(string.format(LocalStrings.PVP_RANK_16,self.matchGoal.winTimes,self.matchGoal.battleTimes))
			-- end
        end

    end
end

-- 创建赛季奖励
function WndPvpRankList:createMatchReward()
    self:initMatchReward()

    local tab = GetElement(self.m_root,"tabReward_WndPvpRankList",WZUITableContainer)
    tab:cleanTable()
    for i = 1, #self.matchReward do
        local cell,tcell = CellPvpRankReward:createElement()
        cell:setTag(i - 1)
        tab:setCellElement(cell)
        tcell:setReward(self.matchReward[i], i)
        tcell:setCallFunc(self,self.onClickRewardItem)
    end
    --我的段位
    local tabInfo = GetPvpDataByLevel(self.m_tData.pvpLevel)
    local sContent
    if tabInfo.id == 1 or tabInfo.id == 999 then
        sContent = string.format(LocalStrings.PVP_RANK_TEXT5, tabInfo.dan)
    else
        sContent = string.format(LocalStrings.PVP_RANK_TEXT3, tabInfo.dan, tabInfo.level2)
    end
    local ftxtMyRank = GetElement(self.m_root,"ftxtMyRank_WndPvpRankList",WZUIFreeTextBox)
    ftxtMyRank:setShowText(sContent)
end

-- 设置checkbox的状态以及显示的容器
function WndPvpRankList:setCheckBoxAndCon(tag)
    for i = 1, 2 do
        local con = GetElement(self.m_root,"con"..i.."_WndPvpRankList",WZUIContainer)
        con:setVisible(i==tag)
    end

    local str = {LocalStrings.PVP_RANK_12,LocalStrings.PVP_RANK_10}
    local txtTitle = GetElement(self.m_root,"txtTitle_WndPvpRankList",WZUILabelTTF)
    txtTitle:setText(str[tag])

    local ftxtEndTime = GetElement(self.m_root,"ftxtEndTime_WndPvpRankList",WZUIFreeTextBox)
    ftxtEndTime:setShowText(string.format(LocalStrings.PVP_RANK_TEXT2, tonumber(self.m_tData.eMonth), tonumber(self.m_tData.eDay), 24))
end

-- 创建loading
function WndPvpRankList:createLoadingBox()
    if not self.loadingId then
        self.loadingId = MsgBoxManager:showLoadingBox(20,self,self.closeLoadingBox)
    end
end

-- 关闭loading
function WndPvpRankList:closeLoadingBox()
    MsgBoxManager:stopLoadingBoxByMsgId(self.loadingId)
    self.loadingId = nil
end

-- 领取奖励后更新
function WndPvpRankList:updateGetRewardState()
    WZLog("-------------------WndPvpRankList:updateGetRewardState-------------")
    self:closeLoadingBox()
    -- 更新奖励列表状态
    local index = self.getRewardData.index
    local tcell = self.cellData[index].tcell
    tcell:rewardGet()

    -- 奖励展示
    WndRewardShow:showById(self.getRewardData.id,self.getRewardData.cnt)

    -- 更新外部红点
    ScenePvpRank:updateBoxState(2,index)
    ScenePvpRank:updateRedPoint()
end

-------------------------------------私有方法模块End----------------------------------------

------------------------------------------------语言适配Begin-------------------------------------
function WndPvpRankList:_adaptLanguage_en(  )
    -- GetElement(self.m_root,"txtCheck1_WndPvpRankList",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(100,0))
    -- GetElement(self.m_root,"txtCheck2_WndPvpRankList",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(100,0))
    -- GetElement(self.m_root,"txtCheck3_WndPvpRankList",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(100,0))
    -- GetElement(self.m_root,"txtCheck4_WndPvpRankList",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(100,0))
end

function WndPvpRankList:_adaptLanguage_th(  )
    -- GetElement(self.m_root,"txtCheck1_WndPvpRankList",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(100,0))
    -- GetElement(self.m_root,"txtCheck2_WndPvpRankList",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(100,0))
    -- GetElement(self.m_root,"txtCheck3_WndPvpRankList",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(100,0))
    -- GetElement(self.m_root,"txtCheck4_WndPvpRankList",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(100,0))
end

function WndPvpRankList:_adaptLanguage_pt(  )
    -- local txt1 = GetElement(self.m_root,"txtCheck1_WndPvpRankList",WZUILabelTTF)
    -- txt1:setDimensions(GlobalMethod:CCSize(110,0))
    -- txt1:setScale(0.7)
    -- local txt2 = GetElement(self.m_root,"txtCheck2_WndPvpRankList",WZUILabelTTF)
    -- txt2:setDimensions(GlobalMethod:CCSize(110,0))
    -- txt2:setScale(0.7)
    -- local txt3 = GetElement(self.m_root,"txtCheck3_WndPvpRankList",WZUILabelTTF)
    -- txt3:setDimensions(GlobalMethod:CCSize(110,0))
    -- txt3:setScale(0.7)
    -- local txt4 = GetElement(self.m_root,"txtCheck4_WndPvpRankList",WZUILabelTTF)
    -- txt4:setDimensions(GlobalMethod:CCSize(110,0))
    -- txt4:setScale(0.7)
end

function WndPvpRankList:_adaptLanguage_vn(  )
    -- local txt1 = GetElement(self.m_root,"txtCheck1_WndPvpRankList",WZUILabelTTF)
    -- txt1:setDimensions(GlobalMethod:CCSize(100,0))
    -- txt1:setScale(0.7)
    -- local txt2 = GetElement(self.m_root,"txtCheck2_WndPvpRankList",WZUILabelTTF)
    -- txt2:setDimensions(GlobalMethod:CCSize(100,0))
    -- txt2:setScale(0.67)
    -- local txt3 = GetElement(self.m_root,"txtCheck3_WndPvpRankList",WZUILabelTTF)
    -- txt3:setDimensions(GlobalMethod:CCSize(100,0))
    -- txt3:setScale(0.7)
    -- local txt4 = GetElement(self.m_root,"txtCheck4_WndPvpRankList",WZUILabelTTF)
    -- txt4:setDimensions(GlobalMethod:CCSize(100,0))
    -- txt4:setScale(0.67)
end

function WndPvpRankList:_adaptLanguage_tr(  )
    GetElement(self.m_root,"txtCheck1_WndPvpRankList",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(100,0))
    GetElement(self.m_root,"txtCheck2_WndPvpRankList",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(100,0))
    GetElement(self.m_root,"txtCheck3_WndPvpRankList",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(100,0))
    GetElement(self.m_root,"txtCheck4_WndPvpRankList",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(100,0))
end
------------------------------------------------语言适配End----------------------------------------