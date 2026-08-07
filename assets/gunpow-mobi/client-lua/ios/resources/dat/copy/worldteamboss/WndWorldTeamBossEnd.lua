--WndWorldTeamBossEnd.lua
--@brief	WndWorldTeamBossEnd的UI模块
--@date		2018/07/19
--@author	Tianxiang_Xu
--@note		世界组队Boss结算界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndWorldTeamBossEnd:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndWorldTeamBossEnd:onExit(element)
	self:_unInit()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

function WndWorldTeamBossEnd:_update()
    -- 显示输赢动画
    SoundManager:playEffectSound(SoundDefine.E_S_BATTLE_WIN)
    
    local conWin = GetElement(self.m_root,"conWin_WndWorldTeamBossEnd",WZUIContainer)
    local conFail = GetElement(self.m_root,"conLose_WndWorldTeamBossEnd",WZUIContainer)
    conWin:setVisible(true)
    conFail:setVisible(false)

    -- 更新信息界面
    self:_updateWinInfo()
end

-- boss的击杀信息
function WndWorldTeamBossEnd:_updateWinInfo()
    WZLog("------------------win info----------------")
    local data = self.data
    -- 击杀者
    local killer = GetElement(self.m_root, "txtKiller_WndWorldTeamBossEnd", WZUILabelTTF)
    local str
    if not data.bWin then
        str = LocalStrings.TEAMBOSS_TEXT12
    else
        str = LocalStrings.TEAMBOSS_TEXT13
    end
    killer:setText(str)

    -- 队伍伤害值
    local txtTeamHurt = GetElement(self.m_root,"txtTeamHurt_WndWorldTeamBossEnd",WZUILabelTTF)
    local teamPercent = string.format("%0.2f", (data.teamHurt/data.bossMaxHp*100))
    teamPercent = "(" .. teamPercent .. "%" .. ")"
    txtTeamHurt:setText(data.teamHurt .. teamPercent)

    -- 我的伤害排名
    local txtMyHurt = GetElement(self.m_root, "txtMyHurt_WndWorldTeamBossEnd", WZUILabelTTF)
    if data.teamHurt > 0 then
        local myPercent = string.format("%0.2f", (data.myHurt/data.teamHurt*100))
        myPercent = "(" .. myPercent .. "%" .. ")"
        txtMyHurt:setText(data.myHurt .. myPercent)
    else
        local myPercent = "(" .. 0 .. "%" .. ")"
        txtMyHurt:setText(data.myHurt .. myPercent)
    end

    -- boss剩余血量
    local txtBossBlood = GetElement(self.m_root, "txtBossBlood_WndWorldTeamBossEnd", WZUILabelTTF)
    local bossPercent = string.format("%0.2f", (data.bossNowHp/data.bossMaxHp*100))
    txtBossBlood:setText(bossPercent .. "%")

    -- 奖励
    local ftxtReward = GetElement(self.m_root, "ftxtReward_WndWorldTeamBossEnd", WZUIFreeTextBox)
    if ftxtReward then
    	local sFormat = [[<I Z="0.6">%s</I><T C="255,236,193" S="20" P="1">%d</T>]]
    	local tConfig = CacheCenter:getGameParam().teamWorldBossConfig
		local tTempConfig = json.decode(tConfig)
		local rewardData = GDatatab_item["id_" .. tTempConfig.rewardItemId]
    	ftxtReward:setShowText(string.format(sFormat, rewardData.icon, data.goldNum))
    end

    -- 玩家角色
    self:_getPlayerSettlementData()
end

-- 2s 后播放粒子效果
function WndWorldTeamBossEnd:OnPlayerParCallBack()
    local parPath = {
        {"ui_jiesuan_fashelihua_01.plist", "ui_jiesuan_fashelihua_02.plist", "ui_jiesuan_fashelihua_03.plist","ui_jiesuan_fashelihua_04.plist" },
        {"ui_jiesuan_lihua_01.plist", "ui_jiesuan_lihua_02.plist", "ui_jiesuan_lihua_03.plist","ui_jiesuan_lihua_04.plist"}
    }
    local con = {"conPar1_WndWorldTeamBossEnd","conPar2_WndWorldTeamBossEnd" }
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
function WndWorldTeamBossEnd:OnAniFinishCallBack()
    WZLog("----------------ani end win-------------",self.data.bWin)
    if self.data.bWin then
        local con = GetElement(self.m_root,"conBtnContinue_WndWorldTeamBossEnd",WZUIContainer)
        con:setVisible(true)
    end
end

-- 动画完成后回调(失败)
function WndWorldTeamBossEnd:OnAniFinishCallBack1()
    WZLog("------------------ani end fail-------------",self.data.bWin)
    if not self.data.bWin then
        local con = GetElement(self.m_root,"conBtnContinue_WndWorldTeamBossEnd",WZUIContainer)
        con:setVisible(true)
    end
end

-- 点击屏幕关闭,赢了回大厅，输了回小岛
function WndWorldTeamBossEnd:onClickContinue()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WZLog("WndWorldTeamBossEnd:onClickContinue", Serialize(self.data))
	if self.data.leaveNum <= 0 or self.data.bWin or self.data.timeOver then
        ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_BackToRoom(WBattleGlobal:getCurrent():getMyRoomId(), WBattleGlobal:getCurrent().m_tMakePairOk.mapId, WBattleGlobal:getCurrent():getMyBattleId())
		SceneWorldTeamBoss:showInterface()
	else
		ProtocolProcessorWorldTeamBossRoom:regAll()
		ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_BackToRoom(WBattleGlobal:getCurrent():getMyRoomId(), WBattleGlobal:getCurrent().m_tMakePairOk.mapId, WBattleGlobal:getCurrent():getMyBattleId())
	end
end
-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配begin----------------------------------------
function WndWorldTeamBossEnd:_adaptLanguage_vn(  )
    GetElement(self.m_root, "txtKiller_WndWorldTeamBossEnd", WZUILabelTTF):setDimensions(GlobalMethod:CCSize(300))
end

function WndWorldTeamBossEnd:_adaptLanguage_en(  )
    GetElement(self.m_root, "txtKiller_WndWorldTeamBossEnd", WZUILabelTTF):setDimensions(GlobalMethod:CCSize(300))
end

function WndWorldTeamBossEnd:_adaptLanguage_pt(  )
    GetElement(self.m_root, "txtKiller_WndWorldTeamBossEnd", WZUILabelTTF):setDimensions(GlobalMethod:CCSize(300))
end

function WndWorldTeamBossEnd:_adaptLanguage_es(  )
    GetElement(self.m_root, "txtKiller_WndWorldTeamBossEnd", WZUILabelTTF):setDimensions(GlobalMethod:CCSize(300))
end
-------------------------------------语言适配End----------------------------------------
