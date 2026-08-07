--WndCommunityBossWin.lua
--@brief    WndCommunityBossWin的UI模块
--@date     2017/01/19
--@note     公会boss副本结算窗口


-------------------------------------公有方法模块Begin--------------------------------------

--@brief    进入场景时被调用的函数
--@param    element:表绑定的UI节点引用
--@note     在这里做场景进入前的准备工作
function WndCommunityBossWin:onEnter(element)
    self.m_root = element
    self.m_bNumAction = false

    SoundManager:playEffectSound(SoundDefine.E_S_BATTLE_WIN)
    -- if WBattleGlobal:getCurrent():getMyHero().m_nBoyOrGirl == 0 then
    --     SoundManager:playEffectSound(SoundDefine.E_S_BATTLE_WIN_BOY,false,true)
    -- else
    --     SoundManager:playEffectSound(SoundDefine.E_S_BATTLE_WIN_GIRL,false,true)
    -- end
    self:_update()
    AdaptLanguage(self)
end


--@brief    onenter函数已执行
function WndCommunityBossWin:onEnterTransitionDidFinish(element)
    WZLog("WndCommunityBossWin:onEnterTransitionDidFinish")
    --弹窗动画
    WindowManagerAni:createAction(self.m_root, true, "actionCallback", self)
end


--@brief    弹窗动画完成后的回调
function WndCommunityBossWin:actionCallback(element, data)
   
end

--@brief    弹窗动画完成后的回调
function WndCommunityBossWin:actionCallback_close(element,data)
    WindowManager:removeWindow(self.m_root , WndCommunityBossWin , true)
end


--@brief    退出场景时被调用的函数
--@param    element:表绑定的UI节点引用
--@note     在这里做场景退出前的清理工作
function WndCommunityBossWin:onExit(element)
    self:_unInit()
    if self.m_root ~= nil then
        self.m_root:disableSchedule()
    end
end

function WndCommunityBossWin:OnTouchBegin(element,pt)
    WZLog("--------------touch begin-----------------")
    local point = self.m_root:getParentElement():convertToNodeSpace(pt)
    local bPoint = WndItemInfo:checkPoint(pt)
    if not bPoint then  WndItemInfo:_onCloseClick() end
end

-- 点击物品后的回调
function WndCommunityBossWin:onClickListItem(tItem, nTag, tData)
    WZLog("------------------click item-------------------")
    WndItemInfo:_onCloseClick()
    local con = GetElement(self.m_root,"conCilck_WndCommunityBossWin",WZUIContainer)
    WndItemInfo:showInfo(tItem.m_root,con,1,tData, false, nil)
end

function WndCommunityBossWin:_update()
    -- 更新信息界面
    self:_updateWinInfo()
end

function WndCommunityBossWin:_updateNumAction(element, dt)
    if self.m_nHurtGetTarget then
        self.m_nCurHurtGet = self.m_nCurHurtGet + self.m_nHurtGetSpeed
        if self.m_nCurHurtGet >= self.m_nHurtGetTarget then
            self.m_nCurHurtGet = self.m_nHurtGetTarget
            self.m_nHurtGetTarget = nil
        end
        GetElement(self.m_root,"labHurtReward_WndCommunityBossWin",WZUILabelTTF):setText(math.floor(self.m_nCurHurtGet))
    end

    if self.m_nHurtGetTarget2 then
        self.m_nCurHurtGet2 = self.m_nCurHurtGet2 + self.m_nHurtGetSpeed2
        if self.m_nCurHurtGet2 >= self.m_nHurtGetTarget2 then
            self.m_nCurHurtGet2 = self.m_nHurtGetTarget2
            self.m_nHurtGetTarget2 = nil
        end
        GetElement(self.m_root,"labHurtReward2_WndCommunityBossWin",WZUILabelTTF):setText(math.floor(self.m_nCurHurtGet2))
    end

    if self.m_nHurtNumTarget then
        self.m_nCurHurtNum = self.m_nCurHurtNum + self.m_nHurtNumSpeed
        if self.m_nCurHurtNum >= self.m_nHurtNumTarget then
            self.m_nCurHurtNum = self.m_nHurtNumTarget
            self.m_nHurtNumTarget = nil
        end
        GetElement(self.m_root,"labHurtNum_WndCommunityBossWin",WZUILabelTTF):setText(math.floor(self.m_nCurHurtNum))
    end
end

-- boss的击杀信息
function WndCommunityBossWin:_updateWinInfo()
    WZLog("------------------win info----------------", Serialize(self.m_tData))
    
    local titleStr
    local isMeKill = false
    if self.m_tData.isWin then
        if self.m_tData.killerId == CacheCenter:getPlayerInfo().id then
            isMeKill = true
            titleStr = LocalStrings.GUILD_BOSS_WIN_TITLE1
        else
            titleStr = string.format(LocalStrings.GUILD_BOSS_WIN_TITLE2,self.m_tData.killerName)
        end

        GetElement(self.m_root,"spineWin_WndCommunityBossWin",WZUISpine):setVisible(true)
        GetElement(self.m_root,"spineOver_WndCommunityBossWin",WZUISpine):setVisible(false)
    else
        titleStr = LocalStrings.GUILD_BOSS_WIN_TITLE3
        GetElement(self.m_root,"spineWin_WndCommunityBossWin",WZUISpine):setVisible(false)
        GetElement(self.m_root,"spineOver_WndCommunityBossWin",WZUISpine):setVisible(true)
    end
    GetElement(self.m_root,"labTitle_WndCommunityBossWin",WZUILabelTTF):setText(titleStr)
    
    GetElement(self.m_root,"labHurtNum_WndCommunityBossWin",WZUILabelTTF):setText(self.m_tData.hurtValue)
    GetElement(self.m_root,"labHurtPercent_WndCommunityBossWin",WZUILabelTTF):setText("(" .. self.m_tData.hurtPercent .. ")")
    GetElement(self.m_root,"labHpPre_WndCommunityBossWin",WZUILabelTTF):setText(self.m_tData.remainHp .. "%")
   
    local labHurtReward = GetElement(self.m_root,"labHurtReward_WndCommunityBossWin",WZUILabelTTF)
    labHurtReward:setText(self.m_tData.hurtReward["num"])

    local parentSize = labHurtReward:getParent():getContentSize()
    local size = labHurtReward:getLabelContentSize()
    local pos = labHurtReward:getRelativePosition()
    GetElement(self.m_root,"imgHurtReward_WndCommunityBossWin",WZUIImage):setRelativePositionLuaTo(pos.x - (size.width + 36)/ parentSize.width,pos.y)

    local labHurtReward2 = GetElement(self.m_root,"labHurtReward2_WndCommunityBossWin",WZUILabelTTF)
    labHurtReward2:setRelativePosition(GlobalMethod:ccp(pos.x - (size.width + 36)/ parentSize.width-0.1,pos.y))
    labHurtReward2:setText(self.m_tData.hurtReward2["num"])

    local parentSize = labHurtReward2:getParent():getContentSize()
    local size = labHurtReward2:getLabelContentSize()
    local pos = labHurtReward2:getRelativePosition()
    GetElement(self.m_root,"imgHurtReward2_WndCommunityBossWin",WZUIImage):setRelativePositionLuaTo(pos.x - (size.width + 36)/ parentSize.width,pos.y)
    
    if self.m_tData.isWin and isMeKill then
        GetElement(self.m_root,"conKillInfo_WndCommunityBossWin",WZUIContainer):setVisible(true)
        local labKillReward = GetElement(self.m_root,"labKillReward_WndCommunityBossWin",WZUILabelTTF)
        labKillReward:setText(self.m_tData.killReward["num"])

        local parentSize = labKillReward:getParent():getContentSize()
        local size = labKillReward:getLabelContentSize()
        local pos = labKillReward:getRelativePosition()
        GetElement(self.m_root,"imgKillReward_WndCommunityBossWin",WZUIImage):setRelativePositionLuaTo(pos.x - (size.width + 36)/ parentSize.width,pos.y)
        self:_showExdReward(true)
    else
        GetElement(self.m_root,"conKillInfo_WndCommunityBossWin",WZUIContainer):setVisible(false)
        self:_showExdReward(false)
    end
   
       -- 玩家角色
    local con = GetElement(self.m_root,"conPlayer_WndCommunityBossWin",WZUIContainer)
    local conP = CreateSelfAni()
    local tmpCon = WZUIContainer:create()
    tmpCon:setRelativePosition(GlobalMethod:ccp(0.5,0.25))
    tmpCon:setUseAbsSize(true)
    tmpCon:setAbsContentSize(GlobalMethod:CCSize(150,150))
    tmpCon:addChild(conP:getAnimNode())
    
    con:addChild(tmpCon)
    conP:play("win", true)

    self.m_nHurtGetTarget = self.m_tData.hurtReward["num"]
    self.m_nHurtGetSpeed = self.m_nHurtGetTarget / 30
    self.m_nCurHurtGet = 0
    labHurtReward:setText(self.m_nCurHurtGet)

    self.m_nHurtGetTarget2 = self.m_tData.hurtReward2["num"]
    self.m_nHurtGetSpeed2 = self.m_nHurtGetTarget2 / 30
    self.m_nCurHurtGet2 = 0
    labHurtReward2:setText(self.m_nCurHurtGet2)

    self.m_nHurtNumTarget = self.m_tData.hurtValue
    self.m_nHurtNumSpeed = self.m_nHurtNumTarget / 30
    self.m_nCurHurtNum = 0
    GetElement(self.m_root,"labHurtNum_WndCommunityBossWin",WZUILabelTTF):setText(self.m_nCurHurtNum)
end


-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

-------------------------------------私有方法模块End----------------------------------------

-- 2s 后播放粒子效果
function WndCommunityBossWin:OnPlayerParCallBack()
    local parPath = {
        {"ui_jiesuan_fashelihua_01.plist", "ui_jiesuan_fashelihua_02.plist", "ui_jiesuan_fashelihua_03.plist","ui_jiesuan_fashelihua_04.plist" },
        {"ui_jiesuan_lihua_01.plist", "ui_jiesuan_lihua_02.plist", "ui_jiesuan_lihua_03.plist","ui_jiesuan_lihua_04.plist"}
    }
    local con = {"conPar1_WndCommunityBossWin","conPar2_WndCommunityBossWin" }
    for i = 1, 2 do
        local con = GetElement(self.m_root, con[i], WZUIContainer)
        for k = 1, 4 do
            local backFire = CCParticleSystemQuad:create("particle/"..parPath[i][k])
            backFire:setAutoRemoveOnFinish(true)
            con:addChild(backFire)
        end
    end
end

-- 动画完成后回调(赢)
function WndCommunityBossWin:OnAniFinishCallBack()
    WZLog("----------------ani end win-------------",self.m_tData.isWin)
    local con = GetElement(self.m_root,"conBtnContinue_WndCommunityBossWin",WZUIContainer)
    con:setVisible(true)
end

-- 动画完成后回调(赢)
function WndCommunityBossWin:OnConFinishCallBack()
    self.m_root:enableSchedule("_updateNumAction",0)
end

-- 点击屏幕关闭,赢了回大厅，输了回小岛
function WndCommunityBossWin:onClickContinue()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
   if self.m_tData.isWin then
        SceneCommunityMain.m_tBossReward = {}
        for i = 1,#self.m_tData.guildRewardList do
            local info = self.m_tData.guildRewardList[i]
            WZLog("WndCommunityBossWin:onClickContinue",info.id,info.num)
            local itemInfo = {itemId = info.id,itemCnt = info.num }
            table.insert( SceneCommunityMain.m_tBossReward, itemInfo )
        end
        replaceScene(SceneCommunityMain:createElement())
   else
        SceneCommunityMain:showInterface("copy")
   end
    WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    显示额外的奖励
--@param    bIKill : 是否是我杀的
function WndCommunityBossWin:_showExdReward(bIKill)
    -- body
    local tExdReward = self.m_tData.exdReward
    if tExdReward == nil or #tExdReward == 0 then 
        GetElement(self.m_root, "conExdReward_WndCommunityBossWin", WZUIContainer):setVisible(false)
        return 
    end

    if not bIKill then
        GetElement(self.m_root, "conExdReward_WndCommunityBossWin", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.5, 0.3))
    end

    for i = 1, #tExdReward do
        local conExdReward = GetElement(self.m_root, "conExdReward" .. i .. "_WndCommunityBossWin", WZUIContainer)
        conExdReward:setVisible(true)
        conExdReward:removeAllChildrenWithCleanup(true)
        local element, tNewObj = CellGoodItem:createElement()
        if element and tNewObj then 
            tNewObj:setCellGoodLocalId(tExdReward[i].id, tExdReward[i].num, 4)
            tNewObj:setItemClickFun(self, self.onClickListItem)
            element:setScale(0.8)
            conExdReward:addChild(element)
        end
    end
end
-------------------------------------语言适配Begin----------------------------------------
function WndCommunityBossWin:_adaptLanguage_pt(  )
    local txtHurtReward = GetElement(self.m_root,"txtHurtReward_WndCommunityBossWin",WZUILabelTTF)
    txtHurtReward:setDimensions(GlobalMethod:CCSize(100))
    local txtKillReward = GetElement(self.m_root,"txtKillReward_WndCommunityBossWin",WZUILabelTTF)
    txtKillReward:setDimensions(GlobalMethod:CCSize(100))
end

function WndCommunityBossWin:_adaptLanguage_vn(  )
    local txtHurtReward = GetElement(self.m_root,"txtHurtReward_WndCommunityBossWin",WZUILabelTTF)
    txtHurtReward:setScale(0.6)
    local txtKillReward = GetElement(self.m_root,"txtKillReward_WndCommunityBossWin",WZUILabelTTF)
    txtKillReward:setScale(0.6)
end

--------------------------------------语言适配End-----------------------------------------
