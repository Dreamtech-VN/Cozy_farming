--CellArenaWinRankIcon.lua
--@brief	CellArenaWinRankIcon的UI模块
--@date		2016-6-29
--@author	binshao
--@note		竞技场战斗结算玩家信息


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellArenaWinRankIcon:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellArenaWinRankIcon:onExit(element)
	self:_unInit()
    NotificationCenter:unregisterNotification("parse_FRIEND_AddFriendOK", self)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

-- 更新
function CellArenaWinRankIcon:_update()
    local template = self:getRankTemplateByLv(self.m_nRankLv)
    if not template then
        WZLog("CellArenaWinRankIcon:_update error",self.m_nRankLv)
        return
    end

    self.m_nCurStarLv = template.level
    self.m_nTargetStarLv = template.level
    self.m_nCurDanLv = template.level2
    self.m_nTargetDanLv = template.level2
    self:_updateIcon()
end

function CellArenaWinRankIcon:_updateNextLv()
    if self.m_bActionDone then
        self.m_bActionDone = false
        self:_updateRanLv()
    end
end

function CellArenaWinRankIcon:_updateRanLv()
    WZLog("CellArenaWinRankIcon:_updateRanLv",self.m_nRankLv,self.m_nNextRankLv,self.m_nCurDanLv,self.m_nTargetDanLv)
    if self.m_nRankLv < self.m_nNextRankLv then
        self.m_nRankLv = self.m_nRankLv + 1
        if self.m_nRankLv >= self.m_nMaxRankLv then
            self.m_bActionDone = true
            self:_updateIcon()
            return
        end
        local nextTemp = self:getRankTemplateByLv(self.m_nRankLv)
        self.m_nTargetStarlv = nextTemp.level
        self.m_nTargetDanLv = nextTemp.level2
        
        if self.m_nCurDanLv ~= self.m_nTargetDanLv then
            self.m_nCurDanLv = self.m_nTargetDanLv
            self:_updateIconAfterStar()
            return
        end
        if self.m_nCurStarLv < self.m_nTargetStarlv then
            self.m_nCurStarLv = self.m_nTargetStarlv
            self:_showStar()
        else
            --星星相等
            self:_updateRanLv()
        end
    elseif self.m_nRankLv > self.m_nNextRankLv then
        self.m_nRankLv = self.m_nRankLv - 1
        local nextTemp = self:getRankTemplateByLv(self.m_nRankLv)
        self.m_nTargetStarlv = nextTemp.level
        self.m_nTargetDanLv = nextTemp.level2

        if self.m_nCurDanLv ~= self.m_nTargetDanLv then
            self.m_nCurDanLv = self.m_nTargetDanLv
            self:_updateIconAfterStar(true)
            return
        end

        if self.m_nCurStarLv > self.m_nTargetStarlv then
            self:_hideStar()
        else
            --星星相等
            self:_updateRanLv()
        end
    else
        self.m_bActionDone = true
    end
end

--@brief 减一个星星
function CellArenaWinRankIcon:_hideStar(doNot)
    WZLog("CellArenaWinRankIcon:_hideStar",self.m_nCurStarLv)
   
    local imgStar = GetElement(self.m_root,string.format("imgStar%d_CellArenaWinRankIcon",self.m_nCurStarLv),WZUIImage)
    self.m_nCurStarLv = self.m_nCurStarLv - 1
    if imgStar then
        imgStar:setOpacity(255)
        imgStar:setVisible(true)
        imgStar:runUIAction(self:_getStartAction(true,doNot))
        self.m_bInStarActoin = true
    else
        self:_updateRanLv()
    end
end

--@brief 加一个星星
function CellArenaWinRankIcon:_showStar()
    WZLog("CellArenaWinRankIcon:_showStar",self.m_nCurStarLv)

    local imgStar = GetElement(self.m_root,string.format("imgStar%d_CellArenaWinRankIcon",self.m_nCurStarLv),WZUIImage)

    if imgStar then
        imgStar:setOpacity(0)
        imgStar:setVisible(true)
        imgStar:runUIAction(self:_getStartAction(false))
        self.m_bInStarActoin = true
    else
        self:_updateRanLv()
    end
end

--@brief 星星动画
function CellArenaWinRankIcon:_getStartAction(isHide,doNot)
    local action = WZUIActionSequence:create()
    action:setIsLoop(false)
    if doNot then
        action:setFinishLuaFunction("_starActionDoneByNot")
    else
        action:setFinishLuaFunction("_starActionDone")
    end
    action:setFinishLuaTable(self)

    local opacity = 255
    local time = 0.5
    if isHide then
        opacity = 0
        time = 0.25
    end
    for i = 1,7 do
        local actionFade = WZUIActionFadeTo:create()
        actionFade:setOpacity(opacity)
        actionFade:setDuration(0.25)
        action:setChildAction(actionFade)
        opacity = opacity == 0 and 255 or 0
        time = time == 0.25 and 0.5 or 0.25
    end
    
    return action
end
--@brief 星星动画完成
function CellArenaWinRankIcon:_starActionDone(element)
    self.m_bInStarActoin = false
    self.m_nCurStarLv = self.m_nTargetStarlv
    self:_updateRanLv()
end

--@brief 星星动画完成
function CellArenaWinRankIcon:_starActionDoneByNot(element)
    self.m_bInStarActoin = false
    self.m_nCurStarLv = self.m_nTargetStarlv
    self:_updateIcon()
    self:_updateRanLv()
end

function CellArenaWinRankIcon:_updateIconAfterStar(isHide)
    WZLog("CellArenaWinRankIcon:_updateIconAfterStar")
    if isHide then
        self:_hideStar(true)
    else
        self.m_nCurStarLv = 0 
        self:_updateIcon()
        self.m_nCurStarLv = self.m_nTargetStarlv
        self:_showStar()
    end
end
--@brief 图标刷新
--@param isUpdate等级变化刷新
function CellArenaWinRankIcon:_updateIcon(isUpdate)
    WZLog("CellArenaWinRankIcon:_updateIcon",tostring(isUpdate),self.m_nCurStarLv)
    local template = self:getRankTemplateByLv(self.m_nRankLv)

    local iconPath = "ui/common/".. template.icon ..".png"
    local imgIcon = GetElement(self.m_root,"imgIcon_CellArenaWinRankIcon",WZUIImage)
    imgIcon:setFile(iconPath)

    local levelStr = template.level2 > 0 and template.level2 or ""
    local labLv = GetElement(self.m_root,"labLv_CellArenaWinRankIcon",WZUILabelTTF)
    labLv:setText(levelStr)
    labLv:setVisible(true)
    local labName = GetElement(self.m_root,"labName_CellArenaWinRankIcon",WZUILabelTTF)
    labName:setText(template.dan .. levelStr)

    local conStarMax = GetElement(self.m_root,"conStarMax_CellArenaWinRankIcon",WZUIContainer)
    local conStar = GetElement(self.m_root,"conStar_CellArenaWinRankIcon",WZUIContainer)

    --隐藏背景 
    if self.m_bIsHidebg then
        GetElement(self.m_root,"imgBg_CellArenaWinRankIcon",WZUIImage):setVisible(false)
    end
    --简单版本
    if self.m_bIsSimple then
        labName:setText(levelStr)
        -- GetElement(self.m_root, "imgRed_CellArenaWinRankIcon", WZUIImage):setScaleX(0.7)
        labName:setFontSize(44)
        conStarMax:setVisible(false)
        conStar:setVisible(false)
        labName:setVisible(false)
        GetElement(self.m_root,"imgGlod_CellArenaWinRankIcon",WZUIImage):setVisible(false)
        return
    end
    labLv:setVisible(false)

    if self.m_nRankLv >= self.m_nMaxRankLv then
        conStarMax:setVisible(true)
        conStar:setVisible(false)
        labStarLv = GetElement(self.m_root, "labStarLv_CellArenaWinRankIcon", WZUILabelTTF)
        labStarLv:setText("X"..tostring(self.m_nRankLv - self.m_nMaxRankLv + 1))
        labName:setText(template.dan)
    else
        local starMax = template.leve5
        local posList = self.m_tPostListT
        if starMax == 4 then
            posList = self.m_tPostListF
        elseif starMax == 5 then
            posList = self.m_tPostListFi
        end

        conStarMax:setVisible(false)
        conStar:setVisible(true)
        for i = 1,starMax do
            local iconStar = GetElement(self.m_root,string.format("imgStar%d_CellArenaWinRankIcon",i),WZUIImage)
            local iconStarBg = GetElement(self.m_root,string.format("imgStarBg%d_CellArenaWinRankIcon",i),WZUIImage)
            iconStar:setVisible(false)
            iconStarBg:setVisible(true)
            
            if i <= self.m_nCurStarLv then
                iconStar:setVisible(true)
                iconStar:setOpacity(255)
            else
                iconStar:setVisible(false)
                iconStar:setOpacity(255)
            end
            local pos = posList[i]
            WZLog("CellArenaWinRankIcon:_updateIcon-two",pos.x,pos.y)
            iconStar:setRelativePosition(GlobalMethod:ccp(pos.x,pos.y))
            iconStarBg:setRelativePosition(GlobalMethod:ccp(pos.x,pos.y))
        end

        if starMax < 5 then
            for i = starMax + 1,5 do
                local iconStar = GetElement(self.m_root,string.format("imgStar%d_CellArenaWinRankIcon",i),WZUIImage)
                local iconStarBg = GetElement(self.m_root,string.format("imgStarBg%d_CellArenaWinRankIcon",i),WZUIImage)
                iconStar:setVisible(false)
                iconStarBg:setVisible(false)
            end
        end
    end

end
-------------------------------------私有方法模块End----------------------------------------

function CellArenaWinRankIcon:_adaptLanguage_es(  )
    GetElement(self.m_root,"labName_CellArenaWinRankIcon",WZUILabelTTF):setScale(0.7)
end