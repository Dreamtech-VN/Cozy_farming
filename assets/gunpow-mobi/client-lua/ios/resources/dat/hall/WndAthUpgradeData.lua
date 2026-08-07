--WndAthUpgradeData.lua
--@brief	WndAthUpgrade的数据模块
--@date		2015/09/02
--@author	zhangming
--@note		竞技等级提升

WndAthUpgrade = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndAthUpgrade:_init()
	self.m_root = nil	 	  			--场景根节点
	self.n_actionTag = nil 
	self.dtTime = nil
	self.b_isOver = false 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndAthUpgrade:_unInit()
	self.m_root = nil
	self.t_date = nil
	self.n_actionTag = nil 
	self.dtTime = nil
	self.b_isOver = nil
end

--@brief    打开竞技等级界面
--@param    data 相关数据
function WndAthUpgrade:Show()
	WZLog("WndAthUpgrade:Show:")
	local lv = CacheCenter:getPlayerInfo().tournamentLevel
	if GlobalGame.g_tPlayerInfo.nAthLevel >= tonumber(lv) then
        WZLog("_checkHasUpdateAthLevel:",tonumber(lv), GlobalGame.g_tPlayerInfo.nAthLevel)
        WZLog("_checkHasUpdateAthLevel:",tonumber(lv), GlobalGame.g_tPlayerInfo.nAthLevel)
        local isEndTeach20, teachStep20 = TeachGroup1:isTeachFinish(20)
        if isEndTeach20 ~= true and teachStep20 >= 5 then
            TeachGroup1:startGroup({20,6,GlobalGame.g_tWndBottomBarObj.m_root})
        elseif isEndTeach20 ~= true and teachStep20 > 0 then
            if CacheCenter:getPlayerInfo().level == 8 then
                PostPlayerEvent:postTeach("20-4")
            end
            TeachGroup1:startGroup({20,5,SceneRoom.m_root})
        end
		return
	end
	local wndthUpgrade = WndAthUpgrade:createElement()
    if wndthUpgrade ~= nil then
        WindowManager:addWindow(wndthUpgrade, WndAthUpgrade, false, nil, nil, true)
    end
end

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndAthUpgrade:createElement()
	local element = WZUISystem:getInstance():createElement("WndAthUpgrade")
	assert(element, "WndAthUpgrade create element failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
