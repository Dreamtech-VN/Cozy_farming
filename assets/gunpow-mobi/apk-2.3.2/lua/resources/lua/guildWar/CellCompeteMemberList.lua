--CellCompeteMemberList.lua
--@brief	CellCompeteMemberList的UI模块
--@date		2016/08/22
--@author	Tianxiang_Xu
--@note		公会战房间成员列表子节点


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellCompeteMemberList:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellCompeteMemberList:onExit(element)
	self:_unInit()
end

--@brief    动态加载数据
function CellCompeteMemberList:onLoadData(element)
    -- body
    local celElement = WZUISystem:getInstance():createElement("CellCompeteMemberList")
    self.m_root:addChild(celElement)

    self.m_bIsLoaded = true
    self:_update()
end

--@brief    点击cell头像回调
function CellCompeteMemberList:onClickHead(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndCheckOther:show(self.m_tData.id)
end

--@brief    点击cell回调
function CellCompeteMemberList:onClickCell(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    if self.m_tData.teamId == 0 then
        WndCheckOther:show(self.m_tData.id)
        return 
    end

    if self.m_tCallBack then
        self.m_tCallBack[2](self.m_tCallBack[1], self.m_root, self.m_tData, self)
    end
end

--@brief    点击右边三个按钮回调
function CellCompeteMemberList:onClickTeamBtn(element)
	WZLog("CellCompeteMemberList:onClickTeamBtn")
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local nTag = element:getTag()    

    if self.m_tData.teamId == 0 then
        if self.m_tData.level < self.m_nJoinLevel then 
            MsgBoxManager:showTipBox(string.format(LocalStrings.COMMYNITY_COMPETE_TEXT36,self.m_nJoinLevel))
            return 
        end
        if self.m_tData.joinTime < self.m_nJoinTimeLimit then
            MsgBoxManager:showTipBox(string.format(LocalStrings.COMMYNITY_COMPETE_TEXT37, self.m_nJoinTimeLimit/3600))
            return 
        end
    end

    if self.m_tCallBack then
        self.m_tCallBack[3](self.m_tCallBack[1], nTag, self.m_tData.id, self)
    end
end

--@brief    重新设置参战队伍
--@param    teamId:队伍号
function CellCompeteMemberList:resetTeamState(teamId)
    --body
    self.m_tData.teamId = teamId
    if self.m_bIsLoaded == false then return end 

    self:_updateTeamState()
end

--@brief    获取会员Id
function CellCompeteMemberList:getPlayerId()
    -- body
    return self.m_tData.id
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    显示cell相关信息
function CellCompeteMemberList:_update()
    -- body
    if self.m_tData == nil then return end 
    --头像
    self:_showHead()
    --背景
    if self.m_tData.id == CacheCenter:getPlayerInfo().id then
        local imgBK = GetElement(self.m_root, "imgBK_CellCompeteMemberList", WZUI9Image)
        if imgBK then
            imgBK:setFile("ui/common/common_scale9_di38.png")
        end
    end
    --名字
    local txtName = GetElement(self.m_root, "txtName_CellCompeteMemberList", WZUILabelTTF)
    if txtName then
        txtName:setText(self.m_tData.name)
    end
    --等级
    local txtLevel = GetElement(self.m_root, "txtLevel_CellCompeteMemberList", WZUILabelTTF)
    if txtLevel then
        txtLevel:setText(self.m_tData.level)
    end
    --职位
    local txtPosition = GetElement(self.m_root, "txtPosition_CellCompeteMemberList", WZUILabelTTF)
    if txtPosition then
        if self.m_tData.position == COMMUNITY_PRESIDENT then       --会长
            txtPosition:setText(LocalStrings.PRESIDENT)
        elseif self.m_tData.position == COMMUNITY_VICE_PRESIDENT then   --副会长
            txtPosition:setText(LocalStrings.VICE_PRESIDENT)
        elseif self.m_tData.position == COMMUNITY_ELDER then   --长老
            txtPosition:setText(LocalStrings.ELDERS)
        elseif self.m_tData.position == COMMUNITY_ELITE then   --精英
            txtPosition:setText(LocalStrings.PICK)
        elseif self.m_tData.position == COMMUNITY_MEMBER then  --普通会员
            txtPosition:setText(LocalStrings.NORMAL_COMMUNITY_MEMBER)
        end 
    end
    --战力
    local txtFighting = GetElement(self.m_root, "txtFighting_CellCompeteMemberList", WZUILabelAtlasFont)
    if txtFighting then
        txtFighting:setText(self.m_tData.fighting)
    end
    --分配队伍
    self:_updateTeamState()
    --设置按钮的点击性
    --self:_setTeamBtnTouchable()
end

--@brief    队伍状态
function CellCompeteMemberList:_updateTeamState()
    -- body
    for i= 1, 3 do
        local imgSel = GetElement(self.m_root, string.format("imgSel%d_CellCompeteMemberList", i), WZUIImage)
        if imgSel then
            if self.m_tData.teamId == i then 
                imgSel:setVisible(true)
            else
                imgSel:setVisible(false)
            end 
        end
    end
end

--@brief    显示头像
function CellCompeteMemberList:_showHead()
    -- body
    conHead = GetElement(self.m_root, "conHead_CellCompeteMemberList", WZUIContainer)
    local element = CellHead:show(conHead,self.m_tData.headId,self.m_tData.faceId,self.m_tData.sex,nil,nil,self.m_tData.vipLevel, self.m_tData.headColor)
    element:setScale(1.18)
end

--@brief    根据玩家所在公会的职位设置按钮的操作性
function CellCompeteMemberList:_setTeamBtnTouchable()
    -- body
    local bCanTouch = false 
    --if self.m_nCommunityPosition == COMMUNITY_PRESIDENT then
	if self.m_tData.id == SceneCommunityKnockout.m_nAdmin then
        bCanTouch = true
    end

    for i = 1, 3 do
        local btnNumber = GetElement(self.m_root, string.format("btnNumber%d_CellCompeteMemberList", i), WZUIButton)
        if btnNumber then
            btnNumber:setTouchEnable(true)
        end
    end
end
-------------------------------------私有方法模块End----------------------------------------
