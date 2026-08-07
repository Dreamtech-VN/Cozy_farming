--WndPvpRankWin.lua
--@brief	WndPvpRankWin的UI模块
--@date		2015-11-16
--@author	binshao
--@note		排位赛结算win


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndPvpRankWin:onEnter(element)
	self.m_root = element
    if ProjConfig.CHANNEL_ID == 1048 or ProjConfig.CHANNEL_ID == 1051 
        or ProjConfig.CHANNEL_ID == 1053 then
        GetElement(self.m_root,"btnFBShare_WndPvpRankWin",WZUIButton):setVisible(true)
    end
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndPvpRankWin:onExit(element)
	self:_unInit()
end

function WndPvpRankWin:ShowWndUI(data)
    local wnd = WndPvpRankWin:createElement()
    WindowManager:addWindow(wnd, WndPvpRankWin, false)
    self:setData(data)
end

function WndPvpRankWin:onContinue()
    WindowManager:removeWindow(self.m_root, self, true)
    local scene = ScenePvpRank:createElement()
    replaceScene(scene)
end

--@brief    战斗胜利分享到Facebook点击事件
function WndPvpRankWin:onFBShare( element )
    SetFBShareByPackage(1)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	更新界面
function WndPvpRankWin:_update()
    self:_initPlayer()
    self:_initEndData()
end




-- 初始化玩家形象
function WndPvpRankWin:_initPlayer()
    local con = GetElement(self.m_root,"conPlayer_WndPvpRankWin",WZUIContainer)
    local aniPlayer = CreateSelfAni()
    con:addChild(aniPlayer:getAnimNode())
    aniPlayer:play("win", true)
end

function WndPvpRankWin:_initEndData()
    local data = self.data

    local tInfo = CacheCenter:getPlayerInfo()
    local tabInfo = GDatatab_rank_segment["id_"..tInfo.segmentLevel]

    local str = {string.format(LocalStrings.COMMUNITYINFO67,data.dayBattleTimes,data.dayWinTimes),data.dayWinStreak,data.score}
	if ProjConfig.LANGUAGE == "en" then
		str = {string.format(LocalStrings.COMMUNITYINFO67,data.dayWinTimes,data.dayBattleTimes),data.dayWinStreak,data.score}
	end
    for i = 1, 3 do
        local txtDesc = GetElement(self.m_root,"txtDesc"..i.."_WndPvpRankWin",WZUILabelTTF)
        txtDesc:setText(str[i])
    end

    -- 排位等级图标和数字
    local lafRankLv = GetElement(self.m_root,"txtRankLv_WndPvpRankWin",WZUILabelAtlasFont)
    lafRankLv:setText(tabInfo.level)
    local lvDi =  GetElement(self.m_root,"imgRankLevel_WndPvpRankWin", WZUIImage)
    lvDi:setFile("ui/common/"..tabInfo.iocn..".png")

    local pro = GetElement(self.m_root,"proExp_WndPvpRankWin",WZUIProgress)
    local exp = GetElement(self.m_root,"txtExp_WndPvpRankWin",WZUILabelTTF)
    pro:setPercentage(math.floor(tInfo.segmentExp/tabInfo.score*100))
    exp:setText(tInfo.segmentExp.."/"..tabInfo.score)

    local conS = GetElement(self.m_root,"conSingle_WndPvpRankWin",WZUIContainer)
    local conD = GetElement(self.m_root,"conDouble_WndPvpRankWin",WZUIContainer)
    if data.isStreak and data.isCheck then
        conD:setVisible(true)
    else
        conS:setVisible(true)
        local img = GetElement(self.m_root,"imgSingle_WndPvpRankWin", WZUIImage)
        if data.isStreak then
            img:setFile("ui/common/common_icon_lsjc.png")
        else
            img:setFile("ui/common/common_icon_zjls.png")
        end
    end
end

-- 2s 后播放粒子效果
function WndPvpRankWin:particleCallBack()
    local parPath = {
        {"ui_jiesuan_fashelihua_01.plist", "ui_jiesuan_fashelihua_02.plist", "ui_jiesuan_fashelihua_03.plist","ui_jiesuan_fashelihua_04.plist" },
        {"ui_jiesuan_lihua_01.plist", "ui_jiesuan_lihua_02.plist", "ui_jiesuan_lihua_03.plist","ui_jiesuan_lihua_04.plist"}
    }
    local con = {"conPar1_WndPvpRankWin","conPar2_WndPvpRankWin" }
    for i = 1, 2 do
        local con = GetElement(self.m_root, con[i], WZUIContainer)
        for k = 1, 4 do
            local backFire = CCParticleSystemQuad:create("particle/"..parPath[i][k])
            backFire:setAutoRemoveOnFinish(true)
            con:addChild(backFire)
        end
    end
end

-- 动画完成后回调
function WndPvpRankWin:aniFinishCallBack()
    local con = GetElement(self.m_root,"conBtnContinue_WndPvpRankWin",WZUIContainer)
    con:setVisible(true)
end
-------------------------------------私有方法模块End----------------------------------------