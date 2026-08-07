--CellGuildWarVSList.lua
--@brief	CellGuildWarVSList的UI模块
--@date		2017/02/08
--@author	Tianxiang_Xu
--@note		公会战小组对战信息


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellGuildWarVSList:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellGuildWarVSList:onExit(element)
	self:_unInit()
end

--@brief    加载cell
function CellGuildWarVSList:onLoadData(element)
    -- body
    local celElement = WZUISystem:getInstance():createElement("CellGuildWarVSList")
    self.m_root:addChild(celElement)
    AdaptLanguage(self)
    self:_update()
end

--@brief    点击cell查看公会信息
function CellGuildWarVSList:onCheckGuildInfoLeft(element)
    -- body
    if self.m_tData[1].guildId ~= -1 then
        SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

        if self.m_tCallBack then
            self.m_tCallBack[2](self.m_tCallBack[1], self.m_tData[1].guildId)
        end
    end
end

--@brief    点击cell查看公会信息
function CellGuildWarVSList:onCheckGuildInfoRight(element)
    -- body
    if self.m_tData[2].guildId ~= -1 then
        SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

        if self.m_tCallBack then
            self.m_tCallBack[2](self.m_tCallBack[1], self.m_tData[2].guildId)
        end
    end
end

--@brief    点击查看按钮回调
function CellGuildWarVSList:onClickCheck(element)
    --body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local nRaceMark = 1
    local nCurDay = SceneCommunityWar:getCurDay(SceneCommunityWar.m_sCommunityTime)
    if nCurDay == 15 then
        nRaceMark = 1
    elseif nCurDay == 16 then
        nRaceMark = 2
    elseif nCurDay == 17 then
        nRaceMark = 3
    elseif nCurDay == 18 then
        nRaceMark = 4
    elseif nCurDay == 19 then
        nRaceMark = 5
    elseif nCurDay == 20 then
        nRaceMark = 6
    end
    if self.m_tCallBack then
        self.m_tCallBack[3](self.m_tCallBack[1], self.m_tData, nRaceMark)
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    显示信息
function CellGuildWarVSList:_update()
    -- body
    local tData = self.m_tData
    --状态
    local txtState = GetElement(self.m_root, "txtState_CellGuildWarVSList", WZUILabelTTF)
    local btnCheck = GetElement(self.m_root, "btnCheck_CellGuildWarVSList", WZUIButton)
    local imgLeftResult = GetElement(self.m_root, "imgLeftResult_CellGuildWarVSList", WZUIImage)
    local imgRightResult = GetElement(self.m_root, "imgRightResult_CellGuildWarVSList", WZUIImage)
    local imgBK = GetElement(self.m_root, "imgBK_CellGuildWarVSList", WZUI9Image)
    if imgBK then
        if tData[1].guildId == CacheCenter:getPlayerInfo().guildId or tData[2].guildId == CacheCenter:getPlayerInfo().guildId then
            imgBK:setFile("ui/common/common_scale9_di38.png")
        end
    end

    local state = self:_getVSState()
    WZLog("CellGuildWarVSList:_update", state)
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
                imgLeftResult:setFile("ui/common/common_icon_shengli.png")
                imgRightResult:setVisible(false)
            elseif tData[2].guildId ~= -1 then
                imgLeftResult:setVisible(false)
                imgRightResult:setFile("ui/common/common_icon_shengli.png")
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
                imgLeftResult:setFile("ui/common/common_icon_shengli.png")
                imgRightResult:setFile("ui/common/common_icon_shibai.png")
            elseif tData[1].guildResult < tData[2].guildResult then
                imgLeftResult:setFile("ui/common/common_icon_shibai.png")
                imgRightResult:setFile("ui/common/common_icon_shengli.png")
            end
        end
    end
    --对战双方
    local txtLeftGroupMark = GetElement(self.m_root, "txtLeftGroupMark_CellGuildWarVSList", WZUILabelTTF)
    local txtRightGroupMark = GetElement(self.m_root, "txtRightGroupMark_CellGuildWarVSList", WZUILabelTTF)
    local txtNameLeft = GetElement(self.m_root, "txtNameLeft_CellGuildWarVSList", WZUILabelTTF)
    local txtNameRight = GetElement(self.m_root, "txtNameRight_CellGuildWarVSList", WZUILabelTTF)
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
            if ProjConfig.LANGUAGE == "pt" then
                txtLeftGroupMark:setRelativePosition(GlobalMethod:ccp(0.45,0.53))
            elseif ProjConfig.LANGUAGE == "en" then
                txtLeftGroupMark:setRelativePosition(GlobalMethod:ccp(0.45,0.53))
            end
        end
    end
    if txtRightGroupMark then
        if tData[2].guildId ~= -1 then
            txtRightGroupMark:setText(sRightGroupMark .. tData[2].guildGroupNo)
        else
            txtRightGroupMark:setText(LocalStrings.COMMUNITY_COMPETE_TEXT15)
            txtRightGroupMark:setColor(GlobalMethod:ccc3(138,122,106))
            txtRightGroupMark:setRelativePosition(GlobalMethod:ccp(0.55,0.53))
            if ProjConfig.LANGUAGE == "en" then
                txtRightGroupMark:setRelativePosition(GlobalMethod:ccp(0.55,0.53))
            elseif ProjConfig.LANGUAGE == "tr" then
                txtRightGroupMark:setRelativePosition(GlobalMethod:ccp(0.65,0.53))
            elseif ProjConfig.LANGUAGE == "pt" then
                txtRightGroupMark:setRelativePosition(GlobalMethod:ccp(0.55,0.53))
            elseif ProjConfig.LANGUAGE == "vn" then
                txtRightGroupMark:setRelativePosition(GlobalMethod:ccp(0.7,0.53))
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
function CellGuildWarVSList:_getVSState()
    -- body
    local tData = self.m_tData
    local nCurTime = SystemTime:getServerTime()
    WZLog("CellGuildWarVSList:_getVSState", Serialize(tData))
    if tData[1].guildId == -1 and tData[2].guildId == -1 then
        return -2
    elseif tData[1].guildId == -1 or tData[2].guildId == -1 then
        return -1 
    elseif tData[1].guildId ~= -1 and tData[2].guildId ~= -1 then
        if SceneCommunityWar.m_nSectionIndex == 3 then
            local nStartTime = SceneCommunityWar.m_nNextStartTime 
            local nEndTime = nStartTime + (SceneCommunityWar:transformStringToTime(SceneCommunityWar.m_sGroupEndTime) - SceneCommunityWar:transformStringToTime(SceneCommunityWar.m_sGroupStartTime))
            if nCurTime < nStartTime then
                return 0
            elseif nCurTime >= nStartTime and nCurTime <= nEndTime then
                if tData[1].guildResult ~= tData[2].guildResult then
                    return 2
                end
                return 1
            elseif nCurTime > nEndTime then
                return 2
            end
        elseif SceneCommunityWar.m_nSectionIndex == 4 then
            if SceneCommunityWar.m_nBottomIndex == 3 then
                return 2
            else
                local nStartTime = SceneCommunityWar.m_nNextStartTime
                local nEndTime = nStartTime + (SceneCommunityWar:transformStringToTime(SceneCommunityWar.m_sFinalEndTime) - SceneCommunityWar:transformStringToTime(SceneCommunityWar.m_sFinalStartTime))
                if nCurTime < nStartTime then
                    return 0
                elseif nCurTime >= nStartTime and nCurTime <= nEndTime then
                    if tData[1].guildResult ~= tData[2].guildResult then
                        return 2
                    end
                    return 1
                elseif nCurTime > nEndTime then
                    return 2
                end
            end
        elseif SceneCommunityWar.m_nSectionIndex > 4 then
            return 2
        end
    end
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin------------------------------------------
function CellGuildWarVSList:_adaptLanguage_en(  )
    local imgLeftResult = GetElement(self.m_root,"imgLeftResult_CellGuildWarVSList",WZUIImage)
    imgLeftResult:setRelativePosition(GlobalMethod:ccp(-0.45,0.5))
    local imgRightResult = GetElement(self.m_root,"imgRightResult_CellGuildWarVSList",WZUIImage)
    imgRightResult:setRelativePosition(GlobalMethod:ccp(1.41,0.5))
    local txtNameRight = GetElement(self.m_root,"txtNameRight_CellGuildWarVSList",WZUILabelTTF)
    txtNameRight:setRelativePosition(GlobalMethod:ccp(0.9,0.53))
end

function CellGuildWarVSList:_adaptLanguage_th(  )
    local imgLeftResult = GetElement(self.m_root,"imgLeftResult_CellGuildWarVSList",WZUIImage)
    imgLeftResult:setRelativePosition(GlobalMethod:ccp(-0.45,0.5))
    local imgRightResult = GetElement(self.m_root,"imgRightResult_CellGuildWarVSList",WZUIImage)
    imgRightResult:setRelativePosition(GlobalMethod:ccp(1.41,0.5))
end

function CellGuildWarVSList:_adaptLanguage_pt(  )
    local imgLeftResult = GetElement(self.m_root,"imgLeftResult_CellGuildWarVSList",WZUIImage)
    imgLeftResult:setRelativePosition(GlobalMethod:ccp(-0.1,0.5))
    imgLeftResult:setScale(0.8)

    local imgRightResult = GetElement(self.m_root,"imgRightResult_CellGuildWarVSList",WZUIImage)
    imgRightResult:setRelativePosition(GlobalMethod:ccp(1.4,0.5))
    imgRightResult:setScale(0.8)
end

function CellGuildWarVSList:_adaptLanguage_vn(  )
    local txtNameRight = GetElement(self.m_root,"txtNameRight_CellGuildWarVSList",WZUILabelTTF)
    txtNameRight:setRelativePosition(GlobalMethod:ccp(0.9,0.53))
    local imgLeftResult = GetElement(self.m_root,"imgLeftResult_CellGuildWarVSList",WZUIImage)
    imgLeftResult:setRelativePosition(GlobalMethod:ccp(-0.45,0.5))
    local imgRightResult = GetElement(self.m_root,"imgRightResult_CellGuildWarVSList",WZUIImage)
    imgRightResult:setRelativePosition(GlobalMethod:ccp(1.41,0.5))
end

function CellGuildWarVSList:_adaptLanguage_es(  )
    local imgLeftResult = GetElement(self.m_root,"imgLeftResult_CellGuildWarVSList",WZUIImage)
    imgLeftResult:setRelativePosition(GlobalMethod:ccp(-0.34,0.5))
    local imgRightResult = GetElement(self.m_root,"imgRightResult_CellGuildWarVSList",WZUIImage)
    imgRightResult:setRelativePosition(GlobalMethod:ccp(1.07,0.5))
end

function CellGuildWarVSList:_adaptLanguage_tr(  )
    local imgLeftResult = GetElement(self.m_root,"imgLeftResult_CellGuildWarVSList",WZUIImage)
    imgLeftResult:setRelativePosition(GlobalMethod:ccp(-0.45,0.5))
    local imgRightResult = GetElement(self.m_root,"imgRightResult_CellGuildWarVSList",WZUIImage)
    imgRightResult:setRelativePosition(GlobalMethod:ccp(1.41,0.5))
    local txtNameRight = GetElement(self.m_root,"txtNameRight_CellGuildWarVSList",WZUILabelTTF)
    txtNameRight:setRelativePosition(GlobalMethod:ccp(0.9,0.53))
end
-------------------------------------语言适配End--------------------------------------------