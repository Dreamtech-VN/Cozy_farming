--WndCommunityBossWinData.lua
--@brief	WndCommunityBossWin的数据模块
--@date		2017/01/19
--@note		公会boss副本结算窗口

WndCommunityBossWin = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndCommunityBossWin:_init()
	self.m_root = nil	 	  			--场景根节点
    
    self.m_tData = nil                  --数据表
   
    self.isVideo = false
    self.m_bSetSpineVisible = nil
    self.m_nDelayTime = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndCommunityBossWin:_unInit()
	self.m_root = nil
     self.isVideo = false
    self.m_bSetSpineVisible = nil
    self.m_nDelayTime = nil
    self.m_tData = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndCommunityBossWin:createElement()
	local element = WZUISystem:getInstance():createElement("WndCommunityBossWin")
	assert(element, "WndCommunityBossWin create element failed!")
	self:_init()
	return element
end

--@brief    显示爬塔副本结算窗口
-- tData = {levelId = 40001, curHpPer = 40, curRoundCnt = 20}
-- levelId 关卡ID
-- curHpPer 当前HP剩余百分比
-- curRoundCnt 当前战斗的回合数
function WndCommunityBossWin:showWindow(tData)
    local wnd = self:createElement()
    if tData == nil then
        WZLog("WndCommunityBossWin:showWindow:   eeee")
    end
    self.m_tData = tData
    WindowManager:addWindow(wnd, self, false)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------



-------------------------------------私有方法模块End----------------------------------------
