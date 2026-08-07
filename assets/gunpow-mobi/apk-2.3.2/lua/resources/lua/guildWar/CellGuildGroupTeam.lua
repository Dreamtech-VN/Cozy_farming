--CellGuildGroupTeam.lua
--@brief	CellGuildGroupTeam的UI模块
--@date		2017/03/01
--@author	Tianxiang_Xu
--@note		淘汰赛小组战队信息界面列表


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellGuildGroupTeam:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellGuildGroupTeam:onExit(element)
	self:_unInit()
end

--@brief    点击观看按钮回调
function CellGuildGroupTeam:onClickCheck(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    if self.m_tCallBack then
        self.m_tCallBack[2](self.m_tCallBack[1], self.m_tData)
    end
end

--@brief    点击查看玩家信息
function CellGuildGroupTeam:onCheckInfo(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local nTag = element:getTag()

    WndCheckOther:show(self.m_tTeamMemberId[nTag])
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    刷新信息
function CellGuildGroupTeam:_update()
    -- body
    local tData = self.m_tData
    --战队号
    self:_showTeamId()
    --左战队头像
    local tMemberList = self:_chooseRealMember(tData.guildData.pInfo[1])
    self:_showHead(tMemberList, "conLeftHead%d_CellGuildGroupTeam", "btnLHead%d_CellGuildGroupTeam")
    if tMemberList == nil or #tMemberList == 0 then
       local txtLeftNull = GetElement(self.m_root,"txtLeftNull_CellGuildGroupTeam", WZUILabelTTF)
       if txtLeftNull then
            txtLeftNull:setText(LocalStrings.COMMUNITY_COMPETE_TEXT15)
        end
    end
    --右战队头像
    tMemberList = self:_chooseRealMember(tData.guildData.pInfo[2])
    self:_showHead(tMemberList, "conRightHead%d_CellGuildGroupTeam", "btnRHead%d_CellGuildGroupTeam")
    if tMemberList == nil or #tMemberList == 0 then
        local txtRightNull = GetElement(self.m_root,"txtRightNull_CellGuildGroupTeam", WZUILabelTTF)
        if txtRightNull then
            txtRightNull:setText(LocalStrings.COMMUNITY_COMPETE_TEXT15)
        end
    end
end

--@brief    设置队伍号
function CellGuildGroupTeam:_showTeamId()
    -- body
    local tData = self.m_tData

    local txtLeftTeamNum = GetElement(self.m_root, "txtLeftTeamNum", WZUILabelAtlasFont)
    if txtLeftTeamNum then
        txtLeftTeamNum:setText(tData.index + 1)
    end

    local txtRightTeamNum = GetElement(self.m_root, "txtRightTeamNum", WZUILabelAtlasFont)
    if txtRightTeamNum then
        txtRightTeamNum:setText(tData.index + 1)
    end
    --观看按钮的显示
    local tMemberList1 = self:_chooseRealMember(tData.guildData.pInfo[1])
    local tMemberList2 = self:_chooseRealMember(tData.guildData.pInfo[2])

    local btnCheck = GetElement(self.m_root, "btnCheck_CellGuildGroupTeam", WZUIButton)
    local txtNoEnemy = GetElement(self.m_root, "txtNoEnemy_CellGuildGroupTeam", WZUILabelTTF)
    if tData.win > 0 and tMemberList1 ~= nil and #tMemberList1 > 0 and tMemberList2 ~= nil and #tMemberList2 > 0 then
        btnCheck:setVisible(true)
    else
        txtNoEnemy:setVisible(true)
    end

    --结果胜负 ui/hero/hero_icon_vssheng.png hero_icon_vsfu.png
    local imgLeftResult = GetElement(self.m_root, "imgLeftResult_CellGuildGroupTeam", WZUIImage)

    if imgLeftResult then 
        if tData.win == tData.guildData.gInfo[1].guildId then
            imgLeftResult:setFile("ui/hero/hero_icon_vssheng.png")
        else
            imgLeftResult:setFile("ui/hero/hero_icon_vsfu.png")
        end
    end

    local imgRightResult = GetElement(self.m_root, "imgRightResult_CellGuildGroupTeam", WZUIImage)
    if tData.win > 0 then
        imgLeftResult:setVisible(true)
        imgRightResult:setVisible(true)
    end
    if imgRightResult then
        if tData.win == tData.guildData.gInfo[2].guildId then
            imgRightResult:setFile("ui/hero/hero_icon_vssheng.png")
        else
            imgRightResult:setFile("ui/hero/hero_icon_vsfu.png")
        end
    end
end

--@brief    队伍成员头像
function CellGuildGroupTeam:_showHead(tMemberList, conName, btnHeadName)
    -- body
    if tMemberList == nil or #tMemberList == 0 then
        return 
    end

    for i = 1, #tMemberList do
        local conHead = GetElement(self.m_root, string.format(conName, i), WZUIContainer)
        table.insert(self.m_tTeamMemberId, tMemberList[i].playerId)
        if conHead then
            conHead:setVisible(true)
            local element = CellHead:show(conHead, tMemberList[i].headId, tMemberList[i].faceId, tMemberList[i].sex, false, nil, tMemberList[i].vip,  tMemberList[i].colour)
            local btnHead = GetElement(self.m_root, string.format(btnHeadName, i), WZUIButton)
            if btnHead then
                btnHead:setTag(self.m_nPlayerIdIndex)
            end

            self.m_nPlayerIdIndex = self.m_nPlayerIdIndex + 1
        end
    end
end

--@brief    挑选出队伍中的有效的队员
function CellGuildGroupTeam:_chooseRealMember(tMemberList)
    -- body
    if tMemberList == nil or #tMemberList == 0 then
        return nil 
    end

    local tTempList = {}
    for i = 1, #tMemberList do
        if tMemberList[i].playerId ~= -1 then
            table.insert(tTempList, tMemberList[i])
        end
    end

    return tTempList
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin------------------------------------------
function CellGuildGroupTeam:_adaptLanguage_vn(  )
    GetElement(self.m_root,"txtNoEnemy_CellGuildGroupTeam",WZUILabelTTF):setScale(0.8)
end
-------------------------------------语言适配End--------------------------------------------