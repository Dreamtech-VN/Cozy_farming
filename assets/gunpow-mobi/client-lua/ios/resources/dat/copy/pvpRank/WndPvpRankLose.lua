--WndPvpRankLose.lua
--@brief	WndPvpRankLose的UI模块
--@date		2015-11-16
--@author	binshao
--@note		排位赛结算win


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndPvpRankLose:onEnter(element)
    self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndPvpRankLose:onExit(element)
    self:_unInit()
end

function WndPvpRankLose:ShowWndUI(data)
    local wnd = WndPvpRankLose:createElement()
    WindowManager:addWindow(wnd, WndPvpRankLose,false)
    self:setData(data)
end

function WndPvpRankLose:onContinue()
    WindowManager:removeWindow(self.m_root, self, true)
    local scene = ScenePvpRank:createElement()
    replaceScene(scene)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	更新界面
function WndPvpRankLose:_update()
    self:_initPlayer()
    self:_initEndData()
end


-- 初始化玩家形象
function WndPvpRankLose:_initPlayer()
    local con = GetElement(self.m_root,"conPlayer_WndPvpRankLose",WZUIContainer)
    local aniPlayer = CreateSelfAni()
    con:addChild(aniPlayer:getAnimNode())
    aniPlayer:play("failure", true)
end

function WndPvpRankLose:_initEndData()
    local data = self.data
    local tInfo = CacheCenter:getPlayerInfo()
    local tabInfo = GDatatab_rank_segment["id_"..tInfo.segmentLevel]

    local str = {string.format(LocalStrings.COMMUNITYINFO67,data.dayBattleTimes,data.dayWinTimes),data.dayWinStreak,data.score}
	if ProjConfig.LANGUAGE == "en" then
		str = {string.format(LocalStrings.COMMUNITYINFO67,data.dayWinTimes,data.dayBattleTimes),data.dayWinStreak,data.score}
	end
    for i = 1, 3 do
        local txtDesc = GetElement(self.m_root,"txtDesc"..i.."_WndPvpRankLose",WZUILabelTTF)
        txtDesc:setText(str[i])
    end

    -- 排位等级图标和数字
    local lafRankLv = GetElement(self.m_root,"txtRankLv_WndPvpRankLose",WZUILabelAtlasFont)
    lafRankLv:setText(tabInfo.level)
    local lvDi =  GetElement(self.m_root,"imgRankLevel_WndPvpRankLose", WZUIImage)
    lvDi:setFile("ui/common/"..tabInfo.iocn..".png")

    local pro = GetElement(self.m_root,"proExp_WndPvpRankLose",WZUIProgress)
    local exp = GetElement(self.m_root,"txtExp_WndPvpRankLose",WZUILabelTTF)
    pro:setPercentage(math.floor(tInfo.segmentExp/tabInfo.score*100))
    exp:setText(tInfo.segmentExp.."/"..tabInfo.score)
end


-- 动画完成后回调
function WndPvpRankLose:aniFinishCallBack()
    local con = GetElement(self.m_root,"conBtnContinue_WndPvpRankLose",WZUIContainer)
    con:setVisible(true)
end
-------------------------------------私有方法模块End----------------------------------------