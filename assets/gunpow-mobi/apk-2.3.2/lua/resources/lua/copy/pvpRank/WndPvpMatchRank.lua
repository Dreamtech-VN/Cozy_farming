--WndPvpMatchRank.lua
--@brief	WndPvpMatchRank的UI模块
--@date		2016-3-30
--@author	binshao
--@note		排位赛赛季奖励


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndPvpMatchRank:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)
end

----@brief onEnter函数执行完成回调
function WndPvpMatchRank:onEnterTransitionDidFinish(element)
    WindowManagerAni:createAction(self.m_root, true, "actionCallback", self)
    AdaptLanguage(self)
end

----@brief    弹窗动画完成后的回调
function WndPvpMatchRank:actionCallback(element, data)
    
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndPvpMatchRank:onExit(element)
	self:_unInit()
end

--@brief	点击关闭按钮时被调用的函数
--@param	element:按钮绑定的UI节点引用
function WndPvpMatchRank:OnClose(element)
    WZLog("WndPvpMatchRank:onClose")
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	WindowManagerAni:createCloseAction(self.m_root, "onActionCallBack", self)
end

--@brief	动画播完后的回调
function WndPvpMatchRank:onActionCallBack()
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief   弹框TIPS
function WndPvpMatchRank:OnTouchBegin(element,pt)
    WndItemInfo:onCloseClick()
end

--@brief	点击单元格时的回调
--@param    nTag,被点击单元格的tag值
--@param    tCell,被点击单元格绑定的lua表对象
function WndPvpMatchRank:onClickCell(nTag, tCell)
end

function WndPvpMatchRank:onClickRewardItem(luaObject,data)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndItemInfo:showInfo(luaObject.m_root,self.m_root,1,data,false)
end

--@brief	点击查看资料按钮时的回调
--@param    element,按钮绑定的UI节点引用
function WndPvpMatchRank:onLook(element)
    WZLog("WndPvpMatchRank:onLook", self.m_nSelCellIndex)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
end

-- 查看段位奖励
function WndPvpMatchRank:onRank1()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    self:setCheckBoxAndCon(1)
    self:createMatchRank1()
end

-- 查看排名奖励
function WndPvpMatchRank:onRank2()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    self:setCheckBoxAndCon(2)
    self:createMatchRank2()
end

-- 显示UI
function WndPvpMatchRank:showWndUI(tag, tData)
    local wnd = WndPvpMatchRank:createElement()
    WindowManager:addWindow(wnd,WndPvpMatchRank)
    self.m_tData = tData
    self:setCheckBoxAndCon(tag)
    if tag == 1 then
        self:createMatchRank1()
    elseif tag == 2 then
        self:createMatchRank2()
    end
end
-------------------------------------公有方法模块End----------------------------------------

-------------------------------------私有方法模块Begin--------------------------------------

-- 创建段位奖励
function WndPvpMatchRank:createMatchRank1()
    self:initMatchReward()

    local tab = GetElement(self.m_root,"tabReward_WndPvpMatchRank",WZUITableContainer)
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
    local ftxtMyRank = GetElement(self.m_root,"ftxtMyRank_WndPvpMatchRank",WZUIFreeTextBox)
    ftxtMyRank:setShowText(sContent)

    local ftxtEndTime = GetElement(self.m_root,"ftxtEndTime_WndPvpMatchRank",WZUIFreeTextBox)
    ftxtEndTime:setShowText(string.format(LocalStrings.PVP_RANK_TEXT2, tonumber(self.m_tData.eMonth), tonumber(self.m_tData.eDay), 24))
end

-- 创建排名奖励
function WndPvpMatchRank:createMatchRank2()
    if self.m_nMyRank == nil then
        self:createLoadingBox()
        ProtocolProcessorScenePvpRank:send_TRIO_GetMathcRank( )
    end
    self:initRankReward()

    local tab = GetElement(self.m_root,"tabReward_WndPvpMatchRank",WZUITableContainer)
    tab:cleanTable()

    for i = 1, #self.m_tRankReward do
        local cell,tcell = CellPvpRankList:createElement()
        cell:setTag(i-1)
        tab:setCellElement(cell)
        tcell:setData(self.m_tRankReward[i])
        tcell:setCallFunc(self,self.onClickRewardItem)
    end

    local ftxtEndTime = GetElement(self.m_root,"ftxtEndTime_WndPvpMatchRank",WZUIFreeTextBox)
    local sFormat = [[<T C="79,60,48" S="18" P="1">%s</T>]]
    ftxtEndTime:setShowText(string.format(sFormat, LocalStrings.PVPRANK_LIST_DESC2))
    --我的排名
    local sContent = string.format(LocalStrings.MY_PVPRANK, tostring(self.m_nMyRank))
    if self.m_nMyRank == -1 then
        sContent = string.format(LocalStrings.MY_PVPRANK, LocalStrings.NOT_IN_RANKLIST)
    end
    local ftxtMyRank = GetElement(self.m_root,"ftxtMyRank_WndPvpMatchRank",WZUIFreeTextBox)
    ftxtMyRank:setShowText(sContent)

    if ProjConfig.LANGUAGE == "tr" then
        ftxtEndTime:setScale(0.8)
        ftxtEndTime:setMaxWidth(650)
    end
end

-- 设置checkbox的状态以及显示的容器
function WndPvpMatchRank:setCheckBoxAndCon(tag)
    self.titleIndex = tag
    for i = 1, 2 do
        local conCheck = GetElement(self.m_root,"conCheck"..i.."_WndPvpMatchRank",WZUIContainer)
        conCheck:setVisible(i==tag)
    end

    local str = {LocalStrings.RANK_SEGMENT_REWARD,LocalStrings.PVP_RANK_11}
    local txtTitle = GetElement(self.m_root,"txtTitle_WndPvpMatchRank",WZUILabelTTF)
    txtTitle:setText(str[tag])
end

-- 创建loading
function WndPvpMatchRank:createLoadingBox()
    if not self.loadingId then
        self.loadingId = MsgBoxManager:showLoadingBox(20,self,self.closeLoadingBox)
    end
end

-- 关闭loading
function WndPvpMatchRank:closeLoadingBox()
    MsgBoxManager:stopLoadingBoxByMsgId(self.loadingId)
    self.loadingId = nil
end
-------------------------------------私有方法模块End----------------------------------------

---------------------------------------------语言适配Begin--------------------------------------
function WndPvpMatchRank:_adaptLanguage_en()
    GetElement(self.m_root,"txtCheck1_WndPvpMatchRank",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(100,0))
    GetElement(self.m_root,"txtCheck2_WndPvpMatchRank",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(100,0))
    GetElement(self.m_root,"txtCheck3_WndPvpMatchRank",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(100,0))
    GetElement(self.m_root,"txtCheck4_WndPvpMatchRank",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(100,0))

    GetElement(self.m_root,"ftxtEndTime_WndPvpMatchRank",WZUIFreeTextBox):setMaxWidth(450)
end

function WndPvpMatchRank:_adaptLanguage_th()
    WZLog("WndPvpMatchRank:_adaptLanguage_th")
    GetElement(self.m_root,"txtCheck1_WndPvpMatchRank",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(100,0))
    GetElement(self.m_root,"txtCheck2_WndPvpMatchRank",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(100,0))
    GetElement(self.m_root,"txtCheck3_WndPvpMatchRank",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(100,0))
    GetElement(self.m_root,"txtCheck4_WndPvpMatchRank",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(100,0))
end

function WndPvpMatchRank:_adaptLanguage_pt()
    -- GetElement(self.m_root,"txtCheck1_WndPvpMatchRank",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(100,0))
    -- GetElement(self.m_root,"txtCheck2_WndPvpMatchRank",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(100,0))
    -- GetElement(self.m_root,"txtCheck3_WndPvpMatchRank",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(100,0))
    -- GetElement(self.m_root,"txtCheck4_WndPvpMatchRank",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(100,0))

    GetElement(self.m_root,"ftxtEndTime_WndPvpMatchRank",WZUIFreeTextBox):setMaxWidth(450)
end

function WndPvpMatchRank:_adaptLanguage_vn()
    local txt1 = GetElement(self.m_root,"txtCheck1_WndPvpMatchRank",WZUILabelTTF)
    txt1:setDimensions(GlobalMethod:CCSize(100,0))
    txt1:setScale(0.7)
    local txt2 = GetElement(self.m_root,"txtCheck2_WndPvpMatchRank",WZUILabelTTF)
    txt2:setDimensions(GlobalMethod:CCSize(100,0))
    txt2:setScale(0.67)
    local txt3 = GetElement(self.m_root,"txtCheck3_WndPvpMatchRank",WZUILabelTTF)
    txt3:setDimensions(GlobalMethod:CCSize(100,0))
    txt3:setScale(0.7)
    local txt4 = GetElement(self.m_root,"txtCheck4_WndPvpMatchRank",WZUILabelTTF)
    txt4:setDimensions(GlobalMethod:CCSize(100,0))
    txt4:setScale(0.67)
end

function WndPvpMatchRank:_adaptLanguage_es()
    local txtCheck1 = GetElement(self.m_root,"txtCheck1_WndPvpMatchRank",WZUILabelTTF)
    txtCheck1:setScale(0.6)
    txtCheck1:setDimensions(GlobalMethod:CCSize(140,0))
    local txtCheck2 = GetElement(self.m_root,"txtCheck2_WndPvpMatchRank",WZUILabelTTF)
    txtCheck2:setScale(0.6)
    txtCheck2:setDimensions(GlobalMethod:CCSize(140,0))
    local txtCheck3 = GetElement(self.m_root,"txtCheck3_WndPvpMatchRank",WZUILabelTTF)
    txtCheck3:setScale(0.6)
    txtCheck3:setDimensions(GlobalMethod:CCSize(140,0))
    local txtCheck4 = GetElement(self.m_root,"txtCheck4_WndPvpMatchRank",WZUILabelTTF)
    txtCheck4:setScale(0.6)
    txtCheck4:setDimensions(GlobalMethod:CCSize(140,0))
end
function WndPvpMatchRank:_adaptLanguage_tr()
    GetElement(self.m_root,"txtCheck1_WndPvpMatchRank",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(100,0))
    GetElement(self.m_root,"txtCheck2_WndPvpMatchRank",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(100,0))
    GetElement(self.m_root,"txtCheck3_WndPvpMatchRank",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(100,0))
    GetElement(self.m_root,"txtCheck4_WndPvpMatchRank",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(100,0))
end

function WndPvpMatchRank:_adaptLanguage_ug()
    local txtCheck1 = GetElement(self.m_root,"txtCheck1_WndPvpMatchRank",WZUILabelTTF)
    txtCheck1:setDimensions(GlobalMethod:CCSize(160,0))
    txtCheck1:setScale(0.52)
    local txtCheck2 = GetElement(self.m_root,"txtCheck2_WndPvpMatchRank",WZUILabelTTF)
    txtCheck2:setDimensions(GlobalMethod:CCSize(160,0))
    txtCheck2:setScale(0.52)
    local txtCheck3 = GetElement(self.m_root,"txtCheck3_WndPvpMatchRank",WZUILabelTTF)
    txtCheck3:setDimensions(GlobalMethod:CCSize(160,0))
    txtCheck3:setScale(0.52)
    local txtCheck4 = GetElement(self.m_root,"txtCheck4_WndPvpMatchRank",WZUILabelTTF)
    txtCheck4:setDimensions(GlobalMethod:CCSize(160,0))
    txtCheck4:setScale(0.52)

    GetElement(self.m_root,"ftxtMyRank_WndPvpMatchRank",WZUIFreeTextBox):setScale(0.8)
    local ftxtEndTime = GetElement(self.m_root,"ftxtEndTime_WndPvpMatchRank",WZUIFreeTextBox)
    ftxtEndTime:setScale(0.8)
    ftxtEndTime:setMaxWidth(450)
end
---------------------------------------------语言适配End----------------------------------------