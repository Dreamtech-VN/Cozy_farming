--CellGuildVSRecord.lua
--@brief	CellGuildVSRecord的UI模块
--@date		2017/02/28
--@author	Tianxiang_Xu
--@note		比赛回顾列表


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellGuildVSRecord:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellGuildVSRecord:onExit(element)
	self:_unInit()
end

--@brief    加载cell
function CellGuildVSRecord:onLoadData(element)
    -- body
    local celElement = WZUISystem:getInstance():createElement("CellGuildVSRecord")
    self.m_root:addChild(celElement)
    self:_update()
    AdaptLanguage(self)
end

--@brief    点击cell查看公会信息
function CellGuildVSRecord:onCheckGuildInfoLeft(element)
    -- body
    if self.m_tData[1].guildId ~= -1 then
        SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

        if self.m_tCallBack then
            self.m_tCallBack[2](self.m_tCallBack[1], self.m_tData[1].guildId)
        end
    end
end

--@brief    点击cell查看公会信息
function CellGuildVSRecord:onCheckGuildInfoRight(element)
    -- body
    if self.m_tData[2].guildId ~= -1 then
        SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

        if self.m_tCallBack then
            self.m_tCallBack[2](self.m_tCallBack[1], self.m_tData[2].guildId)
        end
    end
end

--@brief    点击查看按钮回调
function CellGuildVSRecord:onClickCheck(element)
    --body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    if self.m_tCallBack then
        self.m_tCallBack[3](self.m_tCallBack[1], self.m_tData, self.m_nRaceMark)
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    显示信息
function CellGuildVSRecord:_update()
    -- body
    local tData = self.m_tData
    --状态
    local txtState = GetElement(self.m_root, "txtState_CellGuildVSRecord", WZUILabelTTF)
    local btnCheck = GetElement(self.m_root, "btnCheck_CellGuildVSRecord", WZUIButton)
    local imgLeftResult = GetElement(self.m_root, "imgLeftResult_CellGuildVSRecord", WZUIImage)
    local imgRightResult = GetElement(self.m_root, "imgRightResult_CellGuildVSRecord", WZUIImage)
    local imgBK = GetElement(self.m_root, "imgBK_CellGuildVSRecord", WZUI9Image)
    if imgBK then
        if tData[1].guildId == CacheCenter:getPlayerInfo().guildId or tData[2].guildId == CacheCenter:getPlayerInfo().guildId then
            imgBK:setFile("ui/common/common_scale9_di38.png")
        end
    end
    --赛程编辑
    local txtVSMark = GetElement(self.m_root, "txtVSMark_CellGuildVSRecord", WZUILabelTTF)
    if txtVSMark then
        local sRaceMark = {LocalStrings.COMMUNITYWAR_TEXT35, LocalStrings.COMMONITY_DESC15, LocalStrings.COMMONITY_DESC16, LocalStrings.COMMONITY_DESC17, LocalStrings.COMMONITY_DESC18, LocalStrings.COMMONITY_DESC19}
        txtVSMark:setText(sRaceMark[self.m_nRaceMark])
    end

    local state = self:_getVSState()
    if txtState and btnCheck then
        if state == -2 then
            btnCheck:setVisible(false)
            imgRightResult:setVisible(false)
            txtState:setVisible(true)
            txtState:setText(LocalStrings.COMMONITY_DESC14)
            imgLeftResult:setFile("ui/hero/hero_icon_xvsdz.png")
            imgLeftResult:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
        elseif state == -1 then
            btnCheck:setVisible(false)
            txtState:setVisible(true)
            txtState:setText(LocalStrings.COMMONITY_DESC14)
            if tData[1].guildId ~= -1 then
                imgLeftResult:setFile("ui/hero/hero_icon_vssheng.png")
                imgRightResult:setVisible(false)
            elseif tData[2].guildId ~= -1 then
                imgLeftResult:setVisible(false)
                imgRightResult:setFile("ui/hero/hero_icon_vssheng.png")
            end
        elseif state == 0 then --未开始
            btnCheck:setVisible(false)
            imgRightResult:setVisible(false)
            txtState:setVisible(true)
            txtState:setText(LocalStrings.COMMUNITY_COMPETE_TEXT16)
            imgLeftResult:setFile("ui/hero/hero_icon_xvsdz.png")
            imgLeftResult:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
        elseif state == 1 then --进行中
            btnCheck:setVisible(false)
            imgRightResult:setVisible(false)
            txtState:setVisible(true)
            txtState:setText(LocalStrings.TASK_DOING)
            imgLeftResult:setFile("ui/hero/hero_icon_xvsdz.png")
            imgLeftResult:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
        else
            btnCheck:setVisible(true)
            txtState:setVisible(false)
            if tData[1].guildResult > tData[2].guildResult then
                imgLeftResult:setFile("ui/hero/hero_icon_vssheng.png")
                imgRightResult:setFile("ui/hero/hero_icon_vsfu.png")
            elseif tData[1].guildResult < tData[2].guildResult then
                imgLeftResult:setFile("ui/hero/hero_icon_vsfu.png")
                imgRightResult:setFile("ui/hero/hero_icon_vssheng.png")
            end
        end
    end
    --对战双方
    local txtLeftGroupMark = GetElement(self.m_root, "txtLeftGroupMark_CellGuildVSRecord", WZUILabelTTF)
    local txtRightGroupMark = GetElement(self.m_root, "txtRightGroupMark_CellGuildVSRecord", WZUILabelTTF)
    local txtNameLeft = GetElement(self.m_root, "txtNameLeft_CellGuildVSRecord", WZUILabelTTF)
    local txtNameRight = GetElement(self.m_root, "txtNameRight_CellGuildVSRecord", WZUILabelTTF)
    local sLeftGroupMark
    local sRightGroupMark 
    if self.m_nGroupLeftId == 1 then
        sGroupMark = "A"
    elseif self.m_nGroupLeftId == 2 then
        sGroupMark = "B"
    elseif self.m_nGroupLeftId == 3 then
        sGroupMark = "C"
    elseif self.m_nGroupLeftId == 4 then
        sGroupMark = "D"
    end
    if self.m_nGroupRightId == 1 then
        sRightGroupMark = "A"
    elseif self.m_nGroupRightId == 2 then
        sRightGroupMark = "B"
    elseif self.m_nGroupRightId == 3 then
        sRightGroupMark = "C"
    elseif self.m_nGroupRightId == 4 then
        sRightGroupMark = "D"
    end

    if txtLeftGroupMark then
        if tData[1].guildId ~= -1 then
            txtLeftGroupMark:setText(sGroupMark .. tData[1].guildGroupNo)
        else
            txtLeftGroupMark:setText(LocalStrings.COMMUNITY_COMPETE_TEXT15)
            txtLeftGroupMark:setColor(GlobalMethod:ccc3(138,122,106))
            txtLeftGroupMark:setRelativePosition(GlobalMethod:ccp(0.26,0.53))
            if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "tr" then 
                txtRightGroupMark:setRelativePosition(GlobalMethod:ccp(0.45,0.53))
            end
        end
    end
    if txtRightGroupMark then
        if tData[2].guildId ~= -1 then
            txtRightGroupMark:setText(sRightGroupMark .. tData[2].guildGroupNo)
        else
            txtRightGroupMark:setText(LocalStrings.COMMUNITY_COMPETE_TEXT15)
            txtRightGroupMark:setColor(GlobalMethod:ccc3(138,122,106))
            txtRightGroupMark:setRelativePosition(GlobalMethod:ccp(0.75,0.53))
            if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "tr" then 
                txtRightGroupMark:setRelativePosition(GlobalMethod:ccp(0.57,0.53))
            end
            if ProjConfig.LANGUAGE == "pt" then
                txtRightGroupMark:setRelativePosition(GlobalMethod:ccp(0.5,0.53))
            elseif ProjConfig.LANGUAGE == "en" then
                txtRightGroupMark:setRelativePosition(GlobalMethod:ccp(0.5,0.53))
            end
        end
    end

    if txtNameLeft and tData[1].guildId ~= -1 then
        txtNameLeft:setText(tData[1].guildName)
    end
    if txtNameRight and tData[2].guildId ~= -1 then
        txtNameRight:setText(tData[2].guildName)
    end
end

--@brief    获取状态
function CellGuildVSRecord:_getVSState()
    -- body
    local tData = self.m_tData
    local nCurTime = SystemTime:getServerTime()

    if tData[1].guildId == -1 and tData[2].guildId == -1 then
        return -2
    elseif tData[1].guildId == -1 or tData[2].guildId == -1 then
        return -1 
    elseif tData[1].guildId ~= -1 and tData[2].guildId ~= -1 then
        return 2
    end
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin------------------------------------------
function CellGuildVSRecord:_adaptLanguage_en(  )
    local txtNameRight = GetElement(self.m_root,"txtNameRight_CellGuildVSRecord",WZUILabelTTF)
    txtNameRight:setRelativePosition(GlobalMethod:ccp(0.9,0.53))
end
-------------------------------------语言适配End--------------------------------------------