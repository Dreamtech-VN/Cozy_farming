--WndPvpRankResult.lua
--@brief	WndPvpRankResult的UI模块
--@date		2015-12-10
--@author	binshao
--@note		排位赛结算


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndPvpRankResult:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndPvpRankResult:onExit(element)
	self:_unInit()
end

function WndPvpRankResult:ShowWndUI(data)
    WZLog("-----------WndPvpRankResult:ShowWndUI----------",Serialize(data))
    local wnd = WndPvpRankResult:createElement()
    WindowManager:addWindow(wnd, WndPvpRankResult, false)
    for i = 1, #data do
        WZLog("---result info--------------------",data[i].playerId,data[i].playerLevel,data[i].playerName,data[i].segmentLevel,data[i].segmentExp,
            data[i].dayBattleTimes, data[i].dayWinTimes, data[i].dayWinStreak, data[i].score, data[i].isStreak, data[i].isCheck, data[i].result)
        WZLog("--------------role sex---------------",data[i].role.playerSex)
        WZLog("--------------role serverId---------------",data[i].serverId)
        for k, v in pairs(data[i].role.equip) do
            WZLog("-----------role--------------",k,v)
        end
    end

    local eventData = {fightType = 3,fightMode = 1,fightLevel = 1}
    PostPlayerEvent:postEvent(PostPlayerEvent.event_playerfight, eventData)

--    local data = {}
--    for i = 1, 2 do
--        local info = {result = 0, playerLevel = 1,playerName = "Name",dayBattleTimes = 20,dayWinTimes = 10,dayWinStreak = 5,score = 40, segmentLevel = 8, segmentExp = 99 }
--        table.insert(data,info)
--    end
    self:setData(data)
end

function WndPvpRankResult:onContinue()
    WindowManager:removeWindow(self.m_root, self, true)
    local scene = ScenePvpRank:createElement()
    replaceScene(scene)
end

--@brief    战斗胜利后分享到Facebook点击事件
function WndPvpRankResult:onFBShare( element )
    SetFBShareByPackage(1)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	更新界面
function WndPvpRankResult:_update()
    self:_initBg()
    self:_initPlayer()
end

-- 初始化背景
function WndPvpRankResult:_initBg()
    local isWin =  self:judgeWinOrLose()
    local conWinBg = GetElement(self.m_root,"conWinBg_WndPvpRankResult",WZUIContainer)
    local conLoseBg = GetElement(self.m_root,"conLoseBg_WndPvpRankResult",WZUIContainer)
    conWinBg:setVisible(isWin)
    conLoseBg:setVisible(not isWin)
    if ProjConfig.CHANNEL_ID == 1048 or ProjConfig.CHANNEL_ID == 1051 
        or ProjConfig.CHANNEL_ID == 1053 then
        if isWin then
            GetElement(self.m_root,"btnShareFB_WndPvpRankResult",WZUIButton):setVisible(true)
        end
    end
end

function WndPvpRankResult:_initPlayer()
    local isChangeDir = {false,true}
    for i = 1, 2 do
        local con = GetElement(self.m_root,"conPlayer"..i.."_WndPvpRankResult",WZUIContainer)
        local cell,tcell = CellPvpRankResult:createElement()
        con:addChild(cell)
        tcell:setData(self.data[i],isChangeDir[i])
    end
end

-- 动画完成后回调
function WndPvpRankResult:aniFinishCallBack()
    local con = GetElement(self.m_root,"conBtnContinue_WndPvpRankResult",WZUIContainer)
    con:setVisible(true)
end
-------------------------------------私有方法模块End----------------------------------------