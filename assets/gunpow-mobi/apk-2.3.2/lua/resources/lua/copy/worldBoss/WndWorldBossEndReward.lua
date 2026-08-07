--WndWorldBossEndReward.lua
--@brief	WndWorldBossEndReward的UI模块
--@date		2015-9-22
--@author	binshao
--@note		世界boss结束奖励界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndWorldBossEndReward:onEnter(element)
	self.m_root = element
    if ProjConfig.CHANNEL_ID == 1048 or ProjConfig.CHANNEL_ID == 1051 
        or ProjConfig.CHANNEL_ID == 1053 then
        GetElement(self.m_root,"btnFBShare_WndWorldBossEndReward",WZUIButton):setVisible(true)
    end
    self:initRewardRankInfo()
    AdaptLanguage(self)
end


--@brief    onenter函数已执行
function WndWorldBossEndReward:onEnterTransitionDidFinish(element)
    WZLog("WndWorldBossEndReward:onEnterTransitionDidFinish")
    --弹窗动画
    WindowManagerAni:createAction(self.m_root, true, "actionCallback", self)
end


--@brief    弹窗动画完成后的回调
function WndWorldBossEndReward:actionCallback(element, data)
   
end

--@brief    弹窗动画完成后的回调
function WndWorldBossEndReward:actionCallback_close(element,data)
    WindowManager:removeWindow(self.m_root , WndWorldBossEndReward , true)
end


--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndWorldBossEndReward:onExit(element)
	self:_unInit()
end

function WndWorldBossEndReward:OnTouchBegin(element,pt)
    WZLog("--------------touch begin-----------------")
    local point = self.m_root:getParentElement():convertToNodeSpace(pt)
    local bPoint = WndItemInfo:checkPoint(pt)
    if not bPoint then  WndItemInfo:onCloseClick() end
end

--@brief    战斗胜利分享到Facebook点击事件
function WndWorldBossEndReward:onFBShare( element )
    SetFBShareByPackage(1)
end

-- 点击物品后的回调
function WndWorldBossEndReward:onClickListItem(tItem, nTag, tData)
    WZLog("------------------click item-------------------")
    WndItemInfo:onCloseClick()
    local con = GetElement(self.m_root,"conCilck_WndWorldBossEndReward",WZUIContainer)
    WndItemInfo:showInfo(tItem.m_root,con,1,tData, false, nil)
end

function WndWorldBossEndReward:_update()
    -- 显示输赢动画
    local conWin = GetElement(self.m_root,"conWin_WndWorldBossEndReward",WZUIContainer)
    local conFail = GetElement(self.m_root,"conLose_WndDailyCopySettlement",WZUIContainer)
    conWin:setVisible(self.data.isWin)
    conFail:setVisible(not self.data.isWin)

    -- 更新信息界面
    if self.data.isWin then
        self:_updateWinInfo()
    else
        self:_updateFailInfo()
    end
end

-- boss的击杀信息
function WndWorldBossEndReward:_updateWinInfo()
    WZLog("------------------win info----------------")
    local data = self.data
    local info = GDatatab_world_boss_map["id_"..data.bossId]
    -- 击杀者
    local killer = GetElement(self.m_root,"txtKiller_WndWorldBossEndReward",WZUILabelTTF)
    local str
    if data.killerId == CacheCenter:getPlayerInfo().id then
        str = string.format(LocalStrings.WORLD_BOSS_KILL,info.boss_name)
    else
        str = string.format(LocalStrings.WORLD_BOSS_KILLED,data.killerName,info.boss_name)
    end
    killer:setText(str)

    -- 伤害值
    local hurt = GetElement(self.m_root,"txtAllHurt_WndWorldBossEndReward",WZUILabelTTF)
    hurt:setText(data.hurtValue)

    -- 伤害排名
    local hurtR = GetElement(self.m_root,"txtHurtRank_WndWorldBossEndReward",WZUILabelTTF)
    local str = data.hurtValue > 0 and data.hurtRank or LocalStrings.NONE
    hurtR:setText(str)

    -- 排名奖励
    if data.hurtValue > 0 then
        local reward = self:getRewardRank(data.hurtRank)
        for i = 1, #reward do
            local con = GetElement(self.m_root,"conRankR"..i.."_WndWorldBossEndReward",WZUIContainer)
            local item = self:_createGoodsItem(reward[i])
            con:addChild(item)
        end
    end

    -- 击杀奖励
    local descState = false
    if data.killerId == CacheCenter:getPlayerInfo().id then
        descState = true
        local killReward = self.killInfo[data.bossId][1].reward
        for i = 1, #killReward do
            local con = GetElement(self.m_root,"conKillR"..i.."_WndWorldBossEndReward",WZUIContainer)
            local item = self:_createGoodsItem(killReward[i])
            con:addChild(item)
        end
    end
    local conK =  GetElement(self.m_root,"conKillReward_WndWorldBossEndReward",WZUIContainer)
    local conNK = GetElement(self.m_root,"conNotKillReward_WndWorldBossEndReward",WZUIContainer)
    conK:setVisible(descState)
    conNK:setVisible(not descState)

    -- 玩家角色
    local con = GetElement(self.m_root,"conPlayer_WndWorldBossEndReward",WZUIContainer)
    local conP = CreateSelfAni()
    local tmpCon = WZUIContainer:create()
    tmpCon:setRelativePosition(GlobalMethod:ccp(0.5,0.25))
    tmpCon:setUseAbsSize(true)
    tmpCon:setAbsContentSize(GlobalMethod:CCSize(150,150))
    tmpCon:addChild(conP:getAnimNode())
    
    con:addChild(tmpCon)
    conP:play("win", true)
end


-- boss的击杀信息
function WndWorldBossEndReward:_updateFailInfo()
    WZLog("------------------fail info----------------")
    local data = self.data
    local info = GDatatab_world_boss_map["id_"..data.bossId]
    -- 失败标题
    local txtFail = GetElement(self.m_root,"txtFailTile_WndWorldBossEndReward",WZUILabelTTF)
    local str = string.format(LocalStrings.WORLD_BOSS_NOKILL,info.boss_name)
    txtFail:setText(str)

    -- 伤害值
    local hurt = GetElement(self.m_root,"txtFailAllHurt_WndWorldBossEndReward",WZUILabelTTF)
    hurt:setText(data.hurtValue)

    -- 伤害排名
    local hurtR = GetElement(self.m_root,"txtFailHurtRank_WndWorldBossEndReward",WZUILabelTTF)
    local str = data.hurtValue > 0 and data.hurtRank or LocalStrings.NONE
    hurtR:setText(str)



    -- 排名奖励
    if data.hurtValue > 0 then
        local reward = self:getRewardRank(data.hurtRank)
        for i = 1, #reward do
            local con = GetElement(self.m_root,"conFailRankR"..i.."_WndWorldBossEndReward",WZUIContainer)
            local item = self:_createGoodsItem(reward[i])
            con:addChild(item)
        end
    end

    -- 玩家角色
    local con = GetElement(self.m_root,"conPlayerFail_WndWorldBossEndReward",WZUIContainer)
    local conP = CreateSelfAni()
    local tmpCon = WZUIContainer:create()
    tmpCon:setRelativePosition(GlobalMethod:ccp(0.5,0.25))
    tmpCon:setUseAbsSize(true)
    tmpCon:setAbsContentSize(GlobalMethod:CCSize(150,150))
    tmpCon:addChild(conP:getAnimNode())
    
    con:addChild(tmpCon)
    conP:play("failure", true)
end

-- 创建一个物品
function WndWorldBossEndReward:_createGoodsItem(reward)
    local cell, tcell = CellGoodItem:createElement()
    cell:setScale(0.8)
    tcell:setItemClickFun(self, self.onClickListItem)
    local tData = {
        id = reward[1],
        lastNum = reward[2],
        basicInfo = GetItemLocalData(reward[1])
    }
    tcell:setCellGoodItem(tData, 2)

    return cell
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

-------------------------------------私有方法模块End----------------------------------------

-- 2s 后播放粒子效果
function WndWorldBossEndReward:OnPlayerParCallBack()
    local parPath = {
        {"ui_jiesuan_fashelihua_01.plist", "ui_jiesuan_fashelihua_02.plist", "ui_jiesuan_fashelihua_03.plist","ui_jiesuan_fashelihua_04.plist" },
        {"ui_jiesuan_lihua_01.plist", "ui_jiesuan_lihua_02.plist", "ui_jiesuan_lihua_03.plist","ui_jiesuan_lihua_04.plist"}
    }
    local con = {"conPar1_WndWorldBossEndReward","conPar2_WndWorldBossEndReward" }
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
function WndWorldBossEndReward:OnAniFinishCallBack()
    WZLog("----------------ani end win-------------",self.data.isWin)
    if self.data.isWin then
        local con = GetElement(self.m_root,"conBtnContinue_WndWorldBossEndReward",WZUIContainer)
        con:setVisible(true)
    end
end

-- 动画完成后回调(失败)
function WndWorldBossEndReward:OnAniFinishCallBack1()
    WZLog("------------------ani end fail-------------",self.data.isWin)
    if not self.data.isWin then
        local con = GetElement(self.m_root,"conBtnContinue_WndWorldBossEndReward",WZUIContainer)
        con:setVisible(true)
    end
end

-- 点击屏幕关闭,赢了回大厅，输了回小岛
function WndWorldBossEndReward:onClickContinue()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
--    if self.data.isWin then
--        SceneWorldBoss:showInterface(self.data.bossId)
--    else
--        local sceneIsland = SceneIsland:createElement()
--        replaceScene(sceneIsland)
--    end
    SceneWorldBoss:showInterface(self.data.bossId)
    WindowManager:removeWindow(self.m_root, self, true)
end

-------------------------------------语言适配Begin---------------------------
function WndWorldBossEndReward:_adaptLanguage_tr(  )
    GetElement(self.m_root,"txtHurt_WndWorldBossEndReward",WZUILabelTTF):setFontSize(16)
    GetElement(self.m_root,"txtAllHurt_WndWorldBossEndReward",WZUILabelTTF):setFontSize(18)
    GetElement(self.m_root,"txtRankDes_WndWorldBossEndReward",WZUILabelTTF):setFontSize(13)
    GetElement(self.m_root,"txtHurtRank_WndWorldBossEndReward",WZUILabelTTF):setFontSize(18)
    local txt = GetElement(self.m_root,"txtNotKill_WndWorldBossEndReward",WZUILabelTTF)
    txt:setDimensions(GlobalMethod:CCSize(300,0))
    GetElement(self.m_root,"txtFailHurt_WndWorldBossEndReward",WZUILabelTTF):setFontSize(16)
    GetElement(self.m_root,"txtFailAllHurt_WndWorldBossEndReward",WZUILabelTTF):setFontSize(18)
    GetElement(self.m_root,"txtFailRank_WndWorldBossEndReward",WZUILabelTTF):setFontSize(13)
    GetElement(self.m_root,"txtFailHurtRank_WndWorldBossEndReward",WZUILabelTTF):setFontSize(18)
end

function WndWorldBossEndReward:_adaptLanguage_en(  )
    local txtHurt = GetElement(self.m_root,"txtHurt_WndWorldBossEndReward",WZUILabelTTF)
    txtHurt:setScale(0.7)
    txtHurt:setRelativePosition(GlobalMethod:ccp(0.0453773,0.193937))
    local txtAllHurt = GetElement(self.m_root,"txtAllHurt_WndWorldBossEndReward",WZUILabelTTF)
    txtAllHurt:setScale(0.7)
    txtAllHurt:setRelativePosition(GlobalMethod:ccp(0.310526,0.186))
    local txtRankDes = GetElement(self.m_root,"txtRankDes_WndWorldBossEndReward",WZUILabelTTF)
    txtRankDes:setScale(0.7)
    txtRankDes:setRelativePosition(GlobalMethod:ccp(0.58421,0.201873))
    local txtHurtRank = GetElement(self.m_root,"txtHurtRank_WndWorldBossEndReward",WZUILabelTTF)
    txtHurtRank:setScale(0.7)
    txtHurtRank:setRelativePosition(GlobalMethod:ccp(0.853032,0.2))
    GetElement(self.m_root,"txtNotKill_WndWorldBossEndReward",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(300,0))
    GetElement(self.m_root,"txtFailHurt_WndWorldBossEndReward",WZUILabelTTF):setScale(0.7)
    local txtFailAllHurt = GetElement(self.m_root,"txtFailAllHurt_WndWorldBossEndReward",WZUILabelTTF)
    txtFailAllHurt:setScale(0.7)
    txtFailAllHurt:setRelativePosition(GlobalMethod:ccp(0.310526,0.5))
    GetElement(self.m_root,"txtFailRank_WndWorldBossEndReward",WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root,"txtFailHurtRank_WndWorldBossEndReward",WZUILabelTTF):setScale(0.7)
end

function WndWorldBossEndReward:_adaptLanguage_pt(  )
    local txtHurt = GetElement(self.m_root,"txtHurt_WndWorldBossEndReward",WZUILabelTTF)
    txtHurt:setScale(0.7)
    txtHurt:setRelativePosition(GlobalMethod:ccp(0.0453773,0.193937))
    local txtAllHurt = GetElement(self.m_root,"txtAllHurt_WndWorldBossEndReward",WZUILabelTTF)
    txtAllHurt:setScale(0.7)
    txtAllHurt:setRelativePosition(GlobalMethod:ccp(0.310526,0.186))
    local txtRankDes = GetElement(self.m_root,"txtRankDes_WndWorldBossEndReward",WZUILabelTTF)
    txtRankDes:setScale(0.7)
    txtRankDes:setRelativePosition(GlobalMethod:ccp(0.58421,0.201873))
    local txtHurtRank = GetElement(self.m_root,"txtHurtRank_WndWorldBossEndReward",WZUILabelTTF)
    txtHurtRank:setScale(0.7)
    txtHurtRank:setRelativePosition(GlobalMethod:ccp(0.853032,0.2))
    GetElement(self.m_root,"txtNotKill_WndWorldBossEndReward",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(300,0))
    GetElement(self.m_root,"txtFailHurt_WndWorldBossEndReward",WZUILabelTTF):setScale(0.7)
    local txtFailAllHurt = GetElement(self.m_root,"txtFailAllHurt_WndWorldBossEndReward",WZUILabelTTF)
    txtFailAllHurt:setScale(0.7)
    txtFailAllHurt:setRelativePosition(GlobalMethod:ccp(0.310526,0.5))
    local txtFailRank = GetElement(self.m_root,"txtFailRank_WndWorldBossEndReward",WZUILabelTTF)
    txtFailRank:setScale(0.7)
    txtFailRank:setRelativePosition(GlobalMethod:ccp(0.578947,0.5))
    local txtFailHurtRank = GetElement(self.m_root,"txtFailHurtRank_WndWorldBossEndReward",WZUILabelTTF)
    txtFailHurtRank:setScale(0.7)
    txtFailHurtRank:setRelativePosition(GlobalMethod:ccp(0.842506,0.5))
end

function WndWorldBossEndReward:_adaptLanguage_es(  )
    local txtHurt = GetElement(self.m_root,"txtHurt_WndWorldBossEndReward",WZUILabelTTF)
    txtHurt:setScale(0.7)
    txtHurt:setRelativePosition(GlobalMethod:ccp(0.0453773,0.193937))
    local txtAllHurt = GetElement(self.m_root,"txtAllHurt_WndWorldBossEndReward",WZUILabelTTF)
    txtAllHurt:setScale(0.7)
    txtAllHurt:setRelativePosition(GlobalMethod:ccp(0.355263,0.186))
    local txtRankDes = GetElement(self.m_root,"txtRankDes_WndWorldBossEndReward",WZUILabelTTF)
    txtRankDes:setScale(0.7)
    txtRankDes:setRelativePosition(GlobalMethod:ccp(0.58421,0.201873))
    local txtHurtRank = GetElement(self.m_root,"txtHurtRank_WndWorldBossEndReward",WZUILabelTTF)
    txtHurtRank:setScale(0.7)
    txtHurtRank:setRelativePosition(GlobalMethod:ccp(0.892506,0.2))
    GetElement(self.m_root,"txtNotKill_WndWorldBossEndReward",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(300,0))
    GetElement(self.m_root,"txtFailHurt_WndWorldBossEndReward",WZUILabelTTF):setScale(0.7)
    local txtFailAllHurt = GetElement(self.m_root,"txtFailAllHurt_WndWorldBossEndReward",WZUILabelTTF)
    txtFailAllHurt:setScale(0.7)
    txtFailAllHurt:setRelativePosition(GlobalMethod:ccp(0.352631,0.5))
    local txtFailRank = GetElement(self.m_root,"txtFailRank_WndWorldBossEndReward",WZUILabelTTF)
    txtFailRank:setScale(0.7)
    txtFailRank:setRelativePosition(GlobalMethod:ccp(0.581578,0.5))
    GetElement(self.m_root,"txtFailHurtRank_WndWorldBossEndReward",WZUILabelTTF):setScale(0.7)
end

function WndWorldBossEndReward:_adaptLanguage_vn(  )
    for i = 1, 5 do
        local conRankR = GetElement(self.m_root,"conRankR"..i.."_WndWorldBossEndReward",WZUIContainer)
        conRankR:setRelativePosition(GlobalMethod:ccp((i*2-1)*0.1,0.5))
        conRankR:setScale(0.9)
    end
end
----------------------------------------语言适配End-------------------------