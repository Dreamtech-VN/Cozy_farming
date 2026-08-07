--CellGuildRankList.lua
--@brief	CellGuildRankList的UI模块
--@date		2017/02/04
--@author	Tianxiang_Xu
--@note		公会战积分榜单


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellGuildRankList:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellGuildRankList:onExit(element)
	self:_unInit()
end

--@brief    开始加载
function CellGuildRankList:onLoadData(element)
    -- body
    local celElement = WZUISystem:getInstance():createElement("CellGuildRankList")
    self.m_root:addChild(celElement)
    self.m_bIsLoaded = true

    self:_update()
    AdaptLanguage(self)
end

--@brief    获取公会信息
function CellGuildRankList:onCheckGuildInfo(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    if self.m_tCallBack then
        self.m_tCallBack[2](self.m_tCallBack[1], self.m_tData.guildId)
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    刷新
function CellGuildRankList:_update()
    -- body
    local tData = self.m_tData 
    local imgBK = GetElement(self.m_root, "imgBK_CellGuildRankList", WZUI9Image)
    if imgBK then
        if tData.guildId == CacheCenter:getPlayerInfo().guildId then
            imgBK:setFile("ui/common/frame_lieb_01.png")
        end
    end
    --出线，入围标记
    local nCurDay = SceneCommunityWar:getCurDay(SceneCommunityWar.m_sCommunityTime)
    local imgResultIcon = GetElement(self.m_root, "imgResultIcon_CellGuildRankList", WZUIImage)
    if imgResultIcon then
        if self.m_nType == 1 then
            if nCurDay > 7 and tData.rank <= 4 and tData.guildIntegral > 0 then
                imgResultIcon:setFile("ui/community/common_icon_chuxian.png")
                imgResultIcon:setVisible(true)
            end
        elseif self.m_nType == 2 then
            if nCurDay > 14 and tData.rank <= 32 then
                imgResultIcon:setFile("ui/community/common_icon_ruwei.png")
                imgResultIcon:setVisible(true)
            end
        end
    end
    --排名
    local tRankIcon = {"ui/common/common_icon_1st.png", "ui/common/common_icon_2nd.png", "ui/common/common_icon_3rd.png"}
    if tData.rank <= 3 then
        local imgRankNum = GetElement(self.m_root, "imgRankNum_CellGuildRankList", WZUIImage)
        if imgRankNum then
            imgRankNum:setVisible(true)
            imgRankNum:setFile(tRankIcon[tData.rank])
        end
    else
        local txtLafRankNum = GetElement(self.m_root, "txtLafRankNum_CellGuildRankList", WZUILabelAtlasFont)
        if txtLafRankNum then
            txtLafRankNum:setVisible(true)
            txtLafRankNum:setText(tData.rank)
        end
    end
    --公会名字（会长名字）
    local txtGuildName = GetElement(self.m_root, "txtGuildName_CellGuildRankList", WZUILabelTTF)
    if txtGuildName then
        txtGuildName:setText(tData.guildName)
    end
    local txtPresident = GetElement(self.m_root, "txtPresident_CellGuildRankList", WZUILabelTTF)
    if txtPresident then
        if self.m_nType == 1 then
            txtPresident:setText("(" .. tData.presidentName .. ")")
        else
            local nServerId = tonumber(tData.presidentName)
            local sSeverName = CacheCenter:getServerNameByServerId(nServerId)
            txtPresident:setText("(" .. sSeverName .. ")")
        end
    end
    --积分
    local txtIntegral = GetElement(self.m_root, "txtIntegral_CellGuildRankList", WZUILabelTTF)
    if txtIntegral then
        txtIntegral:setText(tData.guildIntegral)
    end
    --胜率
    local txtWinNum = GetElement(self.m_root, "txtWinNum_CellGuildRankList", WZUILabelTTF)
    if txtWinNum then
        txtWinNum:setText(string.format(LocalStrings.COMMUNITYINFO67, tData.guildFightNum, tData.guildWinNum))
    end
    local txtWinPercent = GetElement(self.m_root, "txtWinPercent_CellGuildRankList", WZUILabelTTF)
    if txtWinPercent then
        if tData.guildFightNum <= 0 then
            txtWinPercent:setText("(" .. LocalStrings.WIN_RATE .. " 0%" .. ")")
        else
            txtWinPercent:setText("(" .. LocalStrings.WIN_RATE .. math.floor(100 * tData.guildWinNum / tData.guildFightNum) .. "%" .. ")")
        end
    end
end




-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配Begin----------------------------------------
function CellGuildRankList:_adaptLanguage_pt()
    local txtWinNum = GetElement(self.m_root, "txtWinNum_CellGuildRankList", WZUILabelTTF)
    if txtWinNum then
        txtWinNum:setScale(0.8)
        txtWinNum:setDimensions(GlobalMethod:CCSize(140))
    end
    local txtWinPercent = GetElement(self.m_root, "txtWinPercent_CellGuildRankList", WZUILabelTTF)
    if txtWinPercent then
        txtWinPercent:setScale(0.8)
    end
end

function CellGuildRankList:_adaptLanguage_es()
    local txtWinNum = GetElement(self.m_root, "txtWinNum_CellGuildRankList", WZUILabelTTF)
    if txtWinNum then
        txtWinNum:setScale(0.8)
        txtWinNum:setDimensions(GlobalMethod:CCSize(140))
    end
    local txtWinPercent = GetElement(self.m_root, "txtWinPercent_CellGuildRankList", WZUILabelTTF)
    if txtWinPercent then
        txtWinPercent:setScale(0.8)
    end
end

function CellGuildRankList:_adaptLanguage_en()
    local txtWinNum = GetElement(self.m_root, "txtWinNum_CellGuildRankList", WZUILabelTTF)
    if txtWinNum then
        txtWinNum:setScale(0.8)
    end
    local txtWinPercent = GetElement(self.m_root, "txtWinPercent_CellGuildRankList", WZUILabelTTF)
    if txtWinPercent then
        txtWinPercent:setScale(0.8)
    end
end
-------------------------------------语言适配End----------------------------------------