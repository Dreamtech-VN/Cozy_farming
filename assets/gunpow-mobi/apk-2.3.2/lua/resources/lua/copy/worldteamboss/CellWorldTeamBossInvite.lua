--CellWorldTeamBossInvite.lua
--@brief	CellWorldTeamBossInvite的UI模块
--@date		2020/05/11
--@author	XTX
--@note		世界组队boss邀请列表Cell


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellWorldTeamBossInvite:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellWorldTeamBossInvite:onExit(element)
	self:_unInit()
end

--@brief	背景按钮函数
--@param	element:表绑定的UI节点引用
function CellWorldTeamBossInvite:onBackClick(element)
    local conImgInVitation = GetElement(self.m_root,"conImgInVitation_CellWorldTeamBossInvite",WZUIContainer)
    if (self.m_nInterface == 3 or self.m_nInterface == 6 or self.m_nInterface == 13) and conImgInVitation:isVisible() then 
        return 
    end 
	element = WZUIButton:luaTo(element)
	local tag = self.m_root:getTag()
    if self.m_nInterface == 7 then 
        if not whetherCanPrivateChat(self.m_tFriend.id) then 
            return 
        end
    end
	self.m_tBackFun[2](self.m_tBackFun[1],self,tag,self.m_tFriend)
end

--@brief    战斗邀请图标显示
function CellWorldTeamBossInvite:showInvateIcon(bInvited)
    self.m_bInvited = bInvited
    if self.m_bIsLoad == false then return end

    local conImgInVitation = GetElement(self.m_root,"conImgInVitation_CellWorldTeamBossInvite",WZUIContainer)
    local btnInvite = GetElement(self.m_root, "btnInvite_CellWorldTeamBossInvite", WZUIButton)
    if conImgInVitation~=nil then 
        if self.m_bInvited then
            conImgInVitation:setVisible(true)
            btnInvite:setVisible(false)
            AdaptLanguage(self)
        else
            btnInvite:setVisible(true)
            conImgInVitation:setVisible(false)
        end
    end 
end

--@brief    加载信息
function CellWorldTeamBossInvite:onLoadData(element)
    -- body
    local cellElement = WZUISystem:getInstance():createElement("CellWorldTeamBossInvite")
    self.m_root:addChild(cellElement)
    self.m_bIsLoad = true
    self:_update()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	更新函数
function CellWorldTeamBossInvite:_update()
	if self.m_root == nil or self.m_tFriend == nil then
		return
	end

    self:_showHeadIcon()
	self:_showName()--显示名称
	self:_showLevel()--显示等级
    self:_showMentoringAndMate() --显示师徒和伴侣关系
    self:_showFight()

    self:showInvateIcon(self.m_bInvited)
    self:_createAthleticsLevel() --竞技邀请，显示竞技等级;英雄联赛邀请，显示退队次数
end
		
--@brief	显示名称
function CellWorldTeamBossInvite:_showName()
	local txtName = WZUILabelTTF:luaTo(self.m_root:getChildElement("txtName_CellWorldTeamBossInvite"))
	txtName:setText(self.m_tFriend.name)
end

--@brief	显示等级
function CellWorldTeamBossInvite:_showLevel()
    WZLog("CellWorldTeamBossInvite:_showLevel()")
    local levelStr = string.format("Lv%d",self.m_tFriend.level)
    GetElement(self.m_root,"txtLevel1_CellWorldTeamBossInvite",WZUILabelTTF):setText(levelStr)
end
--@brief    显示玩家头像
function CellWorldTeamBossInvite:_showHeadIcon()
    WZLog("CellWorldTeamBossInvite:_showHeadIcon()")

    local conHead = GetElement(self.m_root,"conHead_CellWorldTeamBossInvite",WZUIContainer)
    local m_bIsOffline = false   
    if self.m_tFriend.isOnline == 0 or self.m_tFriend.isOnline == false then
        m_bIsOffline = true  
    end
    if m_bIsOffline then 
        WZLog("玩家不在线")
    else 
        WZLog("玩家在线")
    end
    local cellElement =  CellHead:show(conHead,self.m_tFriend.headItemId,self.m_tFriend.faceItemId,self.m_tFriend.sex,m_bIsOffline, nil, self.m_tFriend.vipLevel, self.m_tFriend.headColor)
    cellElement:setScale(1.12)
end

--点击好友头像
function CellWorldTeamBossInvite:event_ClickHead( element )
    WZLog("CellWorldTeamBossInvite:event_ClickHead")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndCheckOther:show(self.m_tFriend.id)
end
--@brief    显示师徒和伴侣关系
function CellWorldTeamBossInvite:_showMentoringAndMate()
    local imgMaster_CellWorldTeamBossInvite = GetElement(self.m_root,"imgMaster_CellWorldTeamBossInvite",WZUIImage)
    --是否是师徒
    local nMentoring = 0 
    WZLog("CellWorldTeamBossInvite:_showMentoringAndMate() 2222", self.m_tFriend.isMentoring)
    if self.m_tFriend.isMentoring then
        local level = self.m_tFriend.level
        if level >= MASTERLEVEL then --师傅
            nMentoring = 1
        else --徒弟
            nMentoring = 2
        end
    end
    WZLog("CellWorldTeamBossInvite:_showMentoringAndMate()", self.m_tFriend.relation, self.m_tFriend.bBestFriend, nMentoring)
    if self.m_nInterface ~= 8 then
        AddRelationIcon(self.m_root, self.m_tFriend.relation, self.m_tFriend.bBestFriend, nMentoring, self.m_tFriend, WndWorldTeamBossInvite.m_root, GlobalMethod:ccp(0.6,0.7)) 
    end

    local IsContains =  CacheCenter:judgeIsContainsById( self.m_tFriend.id )
    self.IsStranger  = not IsContains 
    --陌生人
    if self.m_nInterface == 8 then
        local txtQuitTeamTimes = GetElement(self.m_root, "txtQuitTeamTimes_CellWorldTeamBossInvite", WZUILabelTTF)
        local sQuitTeamTimes = string.format(LocalStrings.LEAGUE_LEAVETEAM_TIMES, self.m_tFriend.tournamentLevel)
        txtQuitTeamTimes:setText(sQuitTeamTimes)
        imgMaster_CellWorldTeamBossInvite:setVisible(false)
    elseif self.m_tFriend.isMentoring == false and self.m_tFriend.relation <= 0 and self.IsStranger then 
        imgMaster_CellWorldTeamBossInvite:setVisible(true)
        imgMaster_CellWorldTeamBossInvite:setFile("ui/common/common_icon_moshengren.png")
    end 
    --跨服标记
    if self.m_nInterface == 3 or self.m_nInterface == 6 or self.m_nInterface == 7 or self.m_nInterface == 11 or self.m_nInterface == 12 or self.m_nInterface == 14 then
        if self.m_tFriend.serverId and  self.m_tFriend.serverId ~= CacheCenter:getPlayerInfo().serverId then
            imgMaster_CellWorldTeamBossInvite:setVisible(false)
            GetElement(self.m_root, "txtQuitTeamTimes_CellWorldTeamBossInvite", WZUILabelTTF):setVisible(false)
            local txtName = GetElement(self.m_root, "txtName_CellWorldTeamBossInvite", WZUILabelTTF)
            if txtName then
                txtName:setRelativePosition(GlobalMethod:ccp(1.5,0.5))
                self:_createKuaFuMark(txtName)
            end
        end
    end
end

--@brief    显示战力
function CellWorldTeamBossInvite:_showFight()
    local txtFight = GetElement(self.m_root, "txtFight_CellWorldTeamBossInvite", WZUILabelAtlasFont)
    txtFight:setText(self.m_tFriend.fighting)
end

--@brief    创建竞技等级
function CellWorldTeamBossInvite:_createAthleticsLevel()
    -- body
    if self.m_nInterface == 3 or self.m_nInterface == 12 then
        -- body
        GetElement(self.m_root, "txtLevel1_CellWorldTeamBossInvite", WZUILabelTTF):setVisible(false)
        local tCurLevelTable = self:_getIntegralName(self.m_tFriend.tournamentLevel)
            
        local sIconFilePath = "ui/common/" .. tCurLevelTable.iocn .. ".png"
        local nPartLevel = tCurLevelTable.iocn_level
        WZLog("CellWorldTeamBossInvite:_createAthleticsLevel",nPartLevel, self.m_tFriend.tournamentLevel, sIconFilePath)
        local imgIcon = WZUIImage:create()
        imgIcon:setFile(sIconFilePath)
        imgIcon:setUseOriginSize(true)
        imgIcon:setAnchorPoint(GlobalMethod:ccp(0.5, 0.5))
        imgIcon:setRelativePosition(GlobalMethod:ccp(0.18, 0.5))

        local atlasLevel = WZUILabelAtlasFont:create()
        atlasLevel:setAnchorPoint(GlobalMethod:ccp(0.5, 0.5))
        atlasLevel:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
        atlasLevel:setCharMapFileName("ui/common_num/common_num_yxtbsz.png")    
        atlasLevel:setHeight(22)
        atlasLevel:setWidth(16)
        atlasLevel:setUseOriginSize(true)
        atlasLevel:setStartChar(48)
        atlasLevel:setText(nPartLevel)
        atlasLevel:setVisible(false)

        if imgIcon then
            imgIcon:addChild(atlasLevel, 10, 10)
            GetElement(self.m_root, "conInfo_CellWorldTeamBossInvite", WZUIContainer):addChild(imgIcon)
        end
    elseif self.m_nInterface == 11 then
        GetElement(self.m_root, "txtLevel1_CellWorldTeamBossInvite", WZUILabelTTF):setVisible(false)
        local conSectionLevel = GetElement(self.m_root, "conSectionLevel_CellPvpRankItem", WZUIContainer)

        local tBasicData = GetPvpDataByLevel(self.m_tFriend.tournamentLevel)
        local celElement, tNewObj = CellPvpLevelIcon:createElement()
        if celElement and tNewObj then
            tNewObj:setData(tBasicData, false, 0.35)
            celElement:setScale(0.35)
            celElement:setRelativePosition(GlobalMethod:ccp(0.18, 0.5))
            GetElement(self.m_root, "conInfo_CellWorldTeamBossInvite", WZUIContainer):addChild(celElement)
        end
    end
end


function CellWorldTeamBossInvite:_getIntegralName(level)
    -- body
    if level == 0 or level == nil then
        level = 1
    end

    local tCurTable = GDatatab_integral[string.format("id_%d", level)]
    if tCurTable == nil then
        local nTableNum = 0
        for k, v in pairs(GDatatab_integral) do
            nTableNum = nTableNum + 1
        end
        tCurTable = GDatatab_integral[string.format("id_%d", nTableNum)]
    end

    return tCurTable
end

--@brief    创建跨服标记
--@param    parentNode:标记添加到的父节点
function CellWorldTeamBossInvite:_createKuaFuMark(parentNode)
    -- body
    local imgMark = WZUIImage:create()
    imgMark:setUseOriginSize(true)
    imgMark:setAnchorPoint(GlobalMethod:ccp(1,0.5))
    imgMark:setRelativePosition(GlobalMethod:ccp(0,0.5))
    imgMark:setFile("ui/common/common_icon_kuafu.png")

    parentNode:addChild(imgMark)
end
-------------------------------------私有方法模块End----------------------------------------
function CellWorldTeamBossInvite:_adaptLanguage_tr( )
    local txtInvited = GetElement(self.m_root,"txtInvited_CellWorldTeamBossInvite",WZUILabelTTF)
    if txtInvited ~= nil then 
        txtInvited:setScale(0.7)
        txtInvited:setDimensions(GlobalMethod:CCSize(80))
    end
end
