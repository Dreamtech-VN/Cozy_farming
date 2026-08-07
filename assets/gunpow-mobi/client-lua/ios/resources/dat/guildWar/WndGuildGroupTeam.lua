--WndGuildGroupTeam.lua
--@brief	WndGuildGroupTeam的UI模块
--@date		2017/03/01
--@author	Tianxiang_Xu
--@note		淘汰赛小组战队信息界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndGuildGroupTeam:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndGuildGroupTeam:onExit(element)
	self:_unInit()
end

--@brief    界面切换完成回调
function WndGuildGroupTeam:onEnterTransitionDidFinish(element)
    -- body
    WindowManagerAni:createAction(self.m_root,true,"onActionFinish",self)
end

--@brief    动画完成
function WndGuildGroupTeam:onActionFinish()
    WZLog("WndGuildGroupTeam:onActionFinish", self.m_nRaceMark,self.m_nCheckGuildId)
--    self:_initData()
    self:_createLoading()
    ProtocolProcessorCommunityWar:send_GUILDWAR_GuildFightRecord()
end

--@brief    
function WndGuildGroupTeam:displayRecord()
    -- body
    self.m_tFindData = self:findVideo(self.m_nRaceMark,self.m_nCheckGuildId)
    table.sort( self.m_tFindData, function (a,b)
        -- body
        return a.index < b.index 
    end )
    self:_setStaticText()
    self:_createTeamVSList()
end

--@brief    关闭按钮回调事件
function WndGuildGroupTeam:onCloseClick(element)
    WZLog("关闭按钮回调事件")
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

    WindowManagerAni:createCloseAction(self.m_root,"onCloseActionCallback",self)
end

--@brief    关闭按钮回调事件
function WndGuildGroupTeam:onCloseActionCallback(element,data)
    WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    点击观看按钮回调
function WndGuildGroupTeam:onClickCheck(tData)
    -- body
    ProtocolProcessorCommunityWar:send_GUILDWAR_GuildFightRecordMes(tData.recordId)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    设置静态文本内容
function WndGuildGroupTeam:_setStaticText()
    -- body
    --标题
    local txtTitle = GetElement(self.m_root, "txtTitle_WndGuildGroupTeam", WZUILabelTTF)
    if txtTitle then
        local sRaceMark = {LocalStrings.COMMUNITYWAR_TEXT35, LocalStrings.COMMONITY_DESC15, LocalStrings.COMMONITY_DESC16, LocalStrings.COMMONITY_DESC17, LocalStrings.COMMONITY_DESC18, LocalStrings.COMMONITY_DESC19}
        
        txtTitle:setText(sRaceMark[self.m_nRaceMark])
    end
end

--@brief    创建两个公会队伍对战列表
function WndGuildGroupTeam:_createTeamVSList()
    -- body
    local conTeam = GetElement(self.m_root, "conTeam_WndGuildGroupTeam", WZUIContainer)
    if self.m_tFindData == nil or #self.m_tFindData == 0 then 
        ShowPanelNullTip( conTeam )
        return 
    end
    removeShowPanelNullTip(conTeam)
    --公会名字
    self:_showCommunityName()

    local tbconRecord = GetElement(self.m_root, "tbcon_WndGuildGroupTeam", WZUITableContainer)
    tbconRecord:cleanTable()

    WZLog("WndGuildGroupTeam:_createTeamVSList", Serialize(self.m_tFindData))
    for i = 1, #self.m_tFindData do
        local element, tNewObj = CellGuildGroupTeam:createElement()
        if element and tNewObj then
            tNewObj:setData(self.m_tFindData[i])
            tNewObj:setCallBackFunc(self, self.onClickCheck)
            element:setTag(i - 1)
            tbconRecord:setCellElement(element)
        end
    end
end

--@brief    公会名字
function WndGuildGroupTeam:_showCommunityName()
    -- body
    --左公会名字
    if self.m_tFindData and self.m_tFindData[1] and self.m_tFindData[1].guildData and self.m_tFindData[1].guildData.gInfo then
        local txtLeftCommunityName = GetElement(self.m_root, "txtLeftCommunityName", WZUILabelTTF)
        if txtLeftCommunityName then
            txtLeftCommunityName:setText(self.m_tFindData[1].guildData.gInfo[1].guildName)
        end
        --右公会名字
        local txtRightCommunityName = GetElement(self.m_root, "txtRightCommunityName", WZUILabelTTF)
        if txtRightCommunityName then
            txtRightCommunityName:setText(self.m_tFindData[1].guildData.gInfo[2].guildName)
        end
    end
end
-------------------------------------私有方法模块End----------------------------------------
